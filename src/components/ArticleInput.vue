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
    const url = "http://localhost:8086"
    const token = "Qc6s7RKI7ZnQpB5ZdesJzEmgd46XLGRmcXv5RJRbhTUc758Ma8g-LQv6_A2p125BZohkhbYnEhVtpeOHJ-BqTw=="
    const org = "MAT"
    const queryApi = new InfluxDB({ url, token }).getQueryApi(org);
  
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
      // Laden Sie die Daten beim Erstellen der Komponente
      this.fetchNames();
    },
  
    methods: {
      async fetchNames() {
      try {
        const fluxQuery = 'from(bucket: "LabData") |> range(start: 0, stop: now()) |> filter(fn: (r) => r["_measurement"] == "HeaderData") |> group(columns: ["_field"])   |> sort(columns: ["_time"], desc: true) |> limit(n: 10)';
        const result = await queryApi.collectRows(fluxQuery);

        if (result.length > 0) {
          
          this.allArticels = [...new Set(result.map(row => row.Article).filter(name => name && name.trim() !== ""))];
          
          this.suggest = this.allArticels.length > 0 ? this.allArticels[0] : "";
          console.log(this.allArticels);
          console.log('hier bin ich');
        } else {
          // Handle the case where result is empty
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
      console.log('this.allArticels:', this.allArticels);
      console.log('this.suggest:', this.suggest);

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
      this.ArticleInput = this.$refs.ArticleInput; // Hinzugefügt: ArticleInput setzen
      // Hinzugefügt: Event Listener für das Schließen des Menüs bei Klick auf die Seite
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
    border: 2px solid black; /* Schwarzer Rand */
    border-radius: 8px; /* Abgerundete Ecken mit 8px Radius */
    padding: 8px; /* Optional: Fügen Sie Padding hinzu, um den Text vom Rand zu trennen */
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
      max-height: 150px; /* Set your desired max height */
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
    </style>
    