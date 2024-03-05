<template>
  <div class="Article_Number-input" ref="Article_NumberInput">
    <div class="input-container">
      <input
        ref="articleNumberInputField"
        type="text"
        v-model="suggest"
        @input="handleInput"
        @focus="handleFocus"
        @click="selectText"
        class="custom-input"
      />
      <div v-if="showSuggestions" class="suggestions-container" @click.stop="">
        <ul>
          <li v-for="suggest in suggestions" @click="selectSuggestion(suggest)">
            {{ suggest }}
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
  
<script>
const { InfluxDB } = require('@influxdata/influxdb-client');
const url = process.env.VUE_APP_INFLUX_URL;
const token = process.env.VUE_APP_INFLUX_TOKEN;
const org = process.env.VUE_APP_INFLUX_ORG;
const queryApi = new InfluxDB({url, token}).getQueryApi(org)

export default {
  data() {
    return {
      suggest: "",
      suggestions: [],
      allArticleNumbers: [],
      showSuggestions: false
    };
  },

  created() {
    this.fetchNames();
  },

  methods: {
    async fetchNames() {
    try {
      const fluxQuery = 'from(bucket: "LabValues") |> range(start: 0, stop: now()) |> filter(fn: (r) => r["_measurement"] == "HeaderData") |> group(columns: ["_field"])   |> sort(columns: ["_time"], desc: true) |> limit(n: 10)';
      const result = await queryApi.collectRows(fluxQuery);
      if (result.length > 0) {
        this.allArticleNumbers = [...new Set(result.map(row => row.Article_Number).filter(name => name && name.trim() !== ""))];
        this.suggest = this.allArticleNumbers.length > 0 ? this.allArticleNumbers[0] : "";
      } else {
        this.allArticleNumbers = [];
        this.suggest = "";
      }
    } catch (error) {
      console.error('Error fetching names:', error);
      this.allArticleNumbers = [];
      this.suggest = "";
    }
  },


    filterNames() {
      if (!this.allArticleNumbers || this.allArticleNumbers.length === 0) {
        this.suggestions = [];
      } else {
        if (this.suggest.length === 0) {
          this.suggestions = this.allArticleNumbers;
        } else {
          this.suggestions = this.allArticleNumbers.filter(name =>
            name.toLowerCase().includes(this.suggest.toLowerCase())
          );
        }
      }
      this.$emit('input-change', 'Article number', this.suggest);
    },

    selectSuggestion(suggest) {
      this.suggest = suggest;
      this.showSuggestions = false;
    },

    handleInput() {
      this.filterNames();
    },

    selectText() {
    this.$refs.articleNumberInputField.select();
  },

    handleFocus() {
      this.showSuggestions = true;
      this.filterNames();
      this.Article_NumberInput = this.$refs.Article_NumberInput; 
      document.addEventListener("click", this.closeSuggestions);
    },

    closeSuggestions(event) {
      if (this.Article_NumberInput && !this.Article_NumberInput.contains(event.target)) {
        this.showSuggestions = false;
        document.removeEventListener("click", this.closeSuggestions);
      }
    }
  },


  watch: {
    suggest() {
      this.filterNames();
    }
  }
};
</script>
  
    
<style scoped>
.custom-input {
  border: 1px solid black; 
  border-radius: 8px; 
  padding: 3px 8px; 
}

.Article_Number-input {
  position: relative;
}

.input-container {
  position: relative;
}

.suggestions-container {
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  max-height: 150px; 
  overflow-y: auto;
  background-color: #fff;
  border: 1px solid #ccc;
  border-top: none;
  z-index: 1;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

li {
  padding: 8px;
  cursor: pointer;
}

li:hover {
  background-color: #f1f1f1;
}

@media print {
  .custom-input {
    border: none;
  }
}
</style>