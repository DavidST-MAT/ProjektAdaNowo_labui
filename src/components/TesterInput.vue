<template>
  <div class="tester-input" ref="testerInput">
    <div class="input-container">
      <input
        type="text"
        v-model="suggest"
        @input="handleInput"
        @focus="handleFocus"
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
export default {
  data() {
    return {
      suggest: "",
      suggestions: [],
      allNames: ["John", "Jane", "Johnny", "Sarah", "David"],
      showSuggestions: false
    };
  },

  methods: {
    filterNames() {
      if (this.suggest.length === 0) {
        this.suggestions = this.allNames;
      } else {
        this.suggestions = this.allNames.filter(name =>
          name.toLowerCase().includes(this.suggest.toLowerCase())
        );
      }
    },
    selectSuggestion(suggest) {
      this.suggest = suggest;
      this.showSuggestions = false;
    },
    handleInput() {
      this.filterNames();
    },
    handleFocus() {
      this.showSuggestions = true;
      this.filterNames();
      // Hinzugefügt: Event Listener für das Schließen des Menüs bei Klick auf die Seite
      document.addEventListener("click", this.closeSuggestions);
    },
    closeSuggestions(event) {
      const testerInput = this.$refs.testerInput;
      if (!testerInput.contains(event.target)) {
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
  .tester-input {
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
  
