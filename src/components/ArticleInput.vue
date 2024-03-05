<template>
  <div class="Article-input" ref="ArticleInput">
    <div class="input-container">
      <input
        ref="articleInputField"
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
      allArticels: [],
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
        this.allArticels = [...new Set(result.map(row => row.Article).filter(name => name && name.trim() !== ""))];
        this.suggest = this.allArticels.length > 0 ? this.allArticels[0] : "";
      } else {
        this.allArticels = [];
        this.suggest = "";
      }
    } catch (error) {
      console.error('Error fetching names:', error);
      this.allArticels = [];
      this.suggest = "";
    }
  },


    filterNames() {
      if (!this.allArticels || this.allArticels.length === 0) {
        this.suggestions = [];
      } else {
        if (this.suggest.length === 0) {
          this.suggestions = this.allArticels;
        } else {
          this.suggestions = this.allArticels.filter(name =>
            name.toLowerCase().includes(this.suggest.toLowerCase())
          );
        }
      }
      this.$emit('input-change', 'Article', this.suggest);
    },
  
    selectSuggestion(suggest) {
      this.suggest = suggest;
      this.showSuggestions = false;
      this.$emit('input', suggest);
    },

    handleInput() {
      this.filterNames();
    },

    selectText() {
    this.$refs.articleInputField.select();
    },

    handleFocus() {
      this.showSuggestions = true;
      this.filterNames();
      this.ArticleInput = this.$refs.ArticleInput; 
      document.addEventListener("click", this.closeSuggestions);
    },

    closeSuggestions(event) {
      if (this.ArticleInput && !this.ArticleInput.contains(event.target)) {
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

.Article-input {
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
    