<template>
  <div class="tester-input" ref="testerInput">
    <div class="input-container">
      <input
        ref="testerInputField"
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
props: {
    value: String 
},

data() {
  return {
    suggest: "",
    suggestions: [],
    allNames: [],
    showSuggestions: false,
    testerInput: null
  };
},

// Calling fetchNames when component is created
created() {
  this.fetchNames();
},


methods: {

  async fetchNames() {
    try {
      // Getting the last Teser from InfluxDB
      const fluxQuery = `from(bucket: "LabData") 
      |> range(start: 0, stop: now()) 
      |> filter(fn: (r) => r["_measurement"] == "HeaderData") 
      |> group(columns: ["_field"])   
      |> sort(columns: ["_time"], desc: true) 
      |> limit(n: 10)`
      
      const result = await queryApi.collectRows(fluxQuery);
      if (result.length > 0) {
        
        // Getting all names from Tester while deleting duplicates and empty strings
        this.allNames = [...new Set(result.map(row => row.Tester).filter(name => name && name.trim() !== ""))];
        
        // Set 'suggest' to the first name in 'allNames' if there is at least one name,
        // otherwise, set it to an empty string.
        this.suggest = this.allNames.length > 0 ? this.allNames[0] : "";
      } else {
        // Handle the scenario where the 'result' array is empty, reset 'allNames' to an empty array and 'suggest' to an empty string
        this.allNames = [];
        this.suggest = "";
      }
    } catch (error) {
      console.error('Error fetching names:', error);
      this.allNames = [];
      this.suggest = "";
    }
  },

  // Function to filter names based on user input and update suggestions
  filterNames() {
    if (!this.allNames || this.allNames.length === 0) {
      // If no names available, set 'suggestions' to an empty array
      this.suggestions = [];
    } else {
      if (this.suggest.length === 0) {
        // If user input is empty, set 'suggestions' to the entire list of names
        this.suggestions = this.allNames;
      } else {
        // If there is user input, filter 'allNames' based on a case-insensitive partial match and set 'suggestions' to the filtered result
        this.suggestions = this.allNames.filter(name =>
          name.toLowerCase().includes(this.suggest.toLowerCase())
        );
      }
    }
    this.$emit('input-change', 'Tester', this.suggest);
  },

  // Function to handle the selection of a suggestion
  selectSuggestion(suggest) {
    this.suggest = suggest;
    this.showSuggestions = false; // Hide the suggestions dropdown after a suggestion is selected
  },

    // Function to handle user input in the component and calling 'filerNames'
    handleInput() {
      this.filterNames(); 
    },

    // Function to select all text within the input field
    selectText() {
      this.$refs.testerInputField.select();
    },

    // Function to handle the focus event on the input field
    handleFocus() {
      this.showSuggestions = true;
      this.filterNames();
      this.testerInput = this.$refs.testerInput;
      document.addEventListener("click", this.closeSuggestions);
    },

    // Function to close the suggestions dropdown when a click occurs outside the input field
    closeSuggestions(event) {
      if (this.testerInput && !this.testerInput.contains(event.target)) {
        this.showSuggestions = false;
        // Remove the click event listener to prevent further checks
        document.removeEventListener("click", this.closeSuggestions);
      }
    }

},


watch: {

  suggest() {
    // When 'suggest' changes, call the 'filterNames' function to update name suggestions
    this.filterNames();
  }
  
}

};
</script>


<style scoped>
.tester-input {
  position: relative;
}

.input-container {
  position: relative;
}

.custom-input {
  border: 1px solid black; 
  border-radius: 8px; 
  padding: 3px 8px; 
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
  
