<template>
  
    <div class="header flex">
      <button @click="handleOpenButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">Open</button>
      
      <div v-if="isModalOpen" class="modal">
        <div class="modal-content">
      
          <div id="app">

            <div class="flex flex-column sm:flex-row flex-wrap space-y-4 sm:space-y-0 items-center justify-between pb-4">
              <button @click="deleteFilter" class="rounded-lg text-sm px-3 py-1.5 dark:bg-red-600 dark:hover:bg-red-700 dark:text-white" type="button">
                Reset Filter
              </button>
              <button @click="closeModal">                          
                <img
                  src="@/assets/x-solid.svg"
                  id="x"
                />
              </button>          
            </div>
    
          <div>

            <table class="text-sm text-left rtl:text-right dark:text-black-300">

              <thead class="text-xs text-white-700 bg-gray-50 dark:bg-red-700 dark:text-white">

                <tr>
                  <th v-for="header in headers" :key="header" scope="col" class="px-4 py-3 uppercase">             
                    {{ header }}
                    <span class="ml-1 cursor-pointer">
                      <div class="dropdown-container">
                        <button @click="toggleFilter" class="filter-button dark:hover:bg-white">
                          <img
                            src="@/assets/filter-solid.svg"
                            id="filter"
                          />
                        </button>
                                                                
                        <!-- Dropdown menu -->
                        <div v-if="showFilter" class="dropdown-menu w-48 bg-white rounded-lg shadow  no-uppercase" :style="{ right: (header === 'Sample number') ? 'auto' : '0' }">
                          <ul class="px-5 py-3 text-xs text-gray-700 dark:text-black" aria-labelledby="dropdownCheckboxButton">
                            <li>

                              <template v-if="header === 'Sample number'">
                                <form class="max-w-xs mx-auto">
                                  <input v-model="inputValue" type="number" id="quantity-input" aria-describedby="helper-text-explanation" class="custom-input" required>
                                  <button type="button" @click="searchSample(inputValue)" class="py-2 ml-2">Search</button>
                                </form>
                              </template>

                              <template v-else-if="header === 'Sample Date/Time'">
                                <div v-for="(item, index) in this.sampeDate" @click="toggleCheckbox(item, 'selectedSampleDate')" :key="index" class="rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedSampleDate" :value="item" />
                                  {{ item }}
                                </div>
                              </template>

                              <template v-else-if="header === 'Tester'">
                                <div v-for="item in this.tester" @click="toggleCheckbox(item, 'selectedTesters')" :key="item" class="p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedTesters" :value="item"  class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500"/>
                                  {{ item }}
                                </div>
                              </template>

                              <template v-else-if="header === 'Test'">
                                <div v-for="item in this.test" :key="item" @click="toggleCheckbox(item, 'selectedTest')" class=" p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedTest" :value="item" class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500"/>
                                  {{ item }}
                                </div>
                              </template>
                                                  
                              <template v-else-if="header === 'Test standard'">
                                <div v-for="item in this.testStandard" @click="toggleCheckbox(item, 'selectedTestStandard')" :key="item" class="p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedTestStandard" :value="item" class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500"/>
                                  {{ item }}
                                </div>
                              </template>
                          
                              <template v-else-if="header === 'Article'">
                                <div v-for="item in this.article" @click="toggleCheckbox(item, 'selectedArticle')" :key="item" class="p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedArticle" :value="item" class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500">
                                  {{ item }}
                                </div>
                              </template>

                              <template v-else-if="header === 'Article number'">
                                <div v-for="item in this.articleNumber" @click="toggleCheckbox(item, 'selectedArticleNumber')" :key="item" class="p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedArticleNumber" :value="item" class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500">
                                  {{ item }}
                                </div>
                              </template>

                              <template v-else-if="header === 'Order number'">
                                <form class="max-w-xs mx-auto">
                                  <input v-model="inputValueOrder" type="text" id="quantity-input" aria-describedby="helper-text-explanation" class="custom-input" required>
                                  <button type="button" @click="searchOrder(inputValueOrder)" class="py-2 ml-2">Search</button>
                                </form>
                              </template>

                              <template v-else-if="header === 'Batch number'">
                                <div v-for="item in this.batchNumber" @click="toggleCheckbox(item, 'selectedBatchNumber')" :key="item" class="p-2 rounded dark:hover:text-white dark:hover:bg-red-700">
                                  <input type="checkbox" v-model="selectedBatchNumber" :value="item" class="w-4 h-4 text-blue-600 rounded dark:bg-gray-600 dark:border-gray-500">
                                  {{ item }}
                                </div>
                              </template>

                            </li>
                          </ul>                    
                        </div>


                      </div>
                    </span>
                  
                  </th>
                </tr>

              </thead>

              <tbody>
                <tr class="bg-white border-b dark:bg-white dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 dark:hover:text-white"  v-for="(item, index) in this.filteredData" :key="index" @click="handleRowClick(item)">

                  <th scope="row" class="px-5 py-3">
                      {{item.SampleNumber}}
                  </th>
                  <td class="px-5 py-3">
                      {{item.SampeDate}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.Tester}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.Test}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.TestStandard}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.Article}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.ArticleNumber}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.OrderNumber}}
                  </td>
                  <td class="px-5 py-3">
                      {{item.BatchNumber}}
                  </td>
                </tr>

              </tbody>

            </table>

          </div>
        </div>

      </div>
    </div>
  </div>
</template>
  
  
<script>
const { InfluxDB} = require('@influxdata/influxdb-client');

const url = process.env.VUE_APP_INFLUX_URL;
const token = process.env.VUE_APP_INFLUX_TOKEN;
const org = process.env.VUE_APP_INFLUX_ORG;
const queryApi = new InfluxDB({url, token}).getQueryApi(org)


export default {

  data() {
    return {
      inputValue: [],
      inputValueOrder: [],
      selectedSampleNumber: [],
      selectedSampleDate: [],
      selectedTesters: [],
      selectedTest: [],
      selectedTestStandard: [],
      selectedArticle: [],
      selectedArticleNumber: [],
      selectedOrderNumber: [],
      selectedBatchNumber: [],
      checkedNames: [],
      sampleNumber: [],
      sampeDate: [],
      tester: [],
      test: [],
      testStandard: [],
      article: [],
      articleNumber: [],
      orderNumber: [],
      batchNumber: [],
      headers: [
      'Sample number',
      'Sample Date/Time',
      'Tester',
      'Test',
      'Test standard',
      'Article',
      'Article number',
      'Order number',
      'Batch number',
      ],
      data: [],
      isModalOpen: false,
      isDropdownVisible: false,
      showFilter: false,
    };
  },


  computed: {

    filteredData() {
      if (this.selectedTesters.length === 0 && this.selectedSampleDate.length === 0 && this.selectedTest.length === 0 && this.selectedTestStandard.length === 0 && this.selectedArticle.length === 0 && this.selectedArticleNumber.length === 0 && this.selectedOrderNumber.length === 0 && this.selectedBatchNumber.length === 0 && this.selectedSampleNumber.length === 0) {
        return this.data;
      } else {
        return this.data.filter(item => 
          this.selectedTesters.includes(item.Tester) || this.selectedSampleDate.includes(item.SampeDate) || this.selectedTest.includes(item.Test) || this.selectedTestStandard.includes(item.TestStandard) || this.selectedArticle.includes(item.Article) || this.selectedArticleNumber.includes(item.ArticleNumber) || this.selectedOrderNumber === item.OrderNumber || this.selectedBatchNumber.includes(item.BatchNumber) || this.selectedSampleNumber === item.SampleNumber
        );
      } 
    },
    // uniqueTesters() {
    // // Entferne Duplikate aus this.filteredData
    // const uniqueTesters = Array.from(new Set(this.filteredData.map(item => item.Tester)));
    // return uniqueTesters;
  },


  methods: {
    handleOpenButtonClick() {
      // Beim Klicken auf den "Open" Button das Modalfenster anzeigen
      this.isModalOpen = true;

      try {
          const fluxQueryHeaderData = `from(bucket: "LabValues") 
          |> range(start: 0, stop: now()) 
          |> filter(fn: (r) => r["_measurement"] == "HeaderData") 
          |> group(columns: ["_field"]) 
          |> sort(columns: ["_time"], desc: true) 
          |> limit(n:50)`
        
        const myQuery = async () => {
          const result = [];

          for await (const { values, tableMeta } of queryApi.iterateRows(fluxQueryHeaderData)) {
            const o = tableMeta.toObject(values);
            result.push({ 
            SampleNumber: o._value, 
            SampeDate: o.Sample_Date, 
            Tester: o.Tester, 
            Test: o.Test, 
            TestStandard: o.Test_Standard, 
            Article: o.Article, 
            ArticleNumber: o.Article_Number, 
            OrderNumber: o.Order_Number, 
            BatchNumber: o.Batch_Number,
            Comment: o.Comment 
            });
          }

          this.sampleNumber = [...new Set(result.map(row => row.SampleNumber))]
          this.sampeDate = [...new Set(result.map(row => row.SampeDate))]
          this.tester = [...new Set(result.map(row => row.Tester))]
          this.test = [...new Set(result.map(row => row.Test))]
          this.testStandard = [...new Set(result.map(row => row.TestStandard))]
          this.article = [...new Set(result.map(row => row.Article))]
          this.articleNumber = [...new Set(result.map(row => row.ArticleNumber))]
          this.orderNumber = [...new Set(result.map(row => row.OrderNumber))]
          this.batchNumber = [...new Set(result.map(row => row.BatchNumber))]
          return result;
        };

        // Execute query and populate data for html table
        myQuery().then((result) => {
          this.data = result
          this.selectedNames = result
          this.filterNames()
          }
        );

      } catch (error) {
      console.error(error); 
      }

    },


    // Function for closing the Open-Modal-Window
    closeModal() {
      this.isModalOpen = false;
    },


    handleRowClick(item) {

      const sample_number = item.SampleNumber

      try {
        const fluxQueryLabValues = `from(bucket: "LabValues") 
        |> range(start: 0, stop: now())
        |> filter(fn: (r) => r["_measurement"] == "LabValues" and r["sample_number"] == "${sample_number}")
        |> group(columns: ["_field"])
        |> sort(columns: ["_time"], desc: true)`
                
        const myQuery = async () => {
          const result = [];

          for await (const { values, tableMeta } of queryApi.iterateRows(fluxQueryLabValues)) {
            const o = tableMeta.toObject(values);
            result.push({ 
              Parameter: o._field,
              Value: o._value
            });
          }
          return result;
        };

          // Execute query and populate data for html table
        myQuery().then((result) => {
          this.data = result
          this.$emit('row-clicked', item, this.data);
          this.isModalOpen = false;
          }
        );

      } catch (error) {
      console.error(error); 
      }

    },


  deleteFilter() {
      this.isDropdownVisible = !this.isDropdownVisible;
    },


  selectOption(index) {
    this.selectedOption = this.dropdownOptions[index].label;
    this.isDropdownVisible = false;
    console.log('Selected option:', this.dropdownOptions[index].value);
  },


  toggleFilter() {
    this.showFilter = !this.showFilter;
  },


  filterHeader() {
  },


  filterNames() {
    console.log(this.selectedNames)
    this.filteredNames = this.data.filter(name => this.selectedNames.includes(name));
    console.log(this.filteredNames)
  },


  searchSample(inputValue) {
    this.selectedSampleNumber = inputValue;
  },


  searchOrder(inputValueOrder){
    this.selectedOrderNumber = inputValueOrder
  },


  // Toggles the Checkbox by clicking the div tag
  toggleCheckbox(item, key) {
    const index = this[key].indexOf(item);

    if (index !== -1) {
      this[key].splice(index, 1);
    } else {
      this[key].push(item);
    }
  },


  deleteFilter() {
    this.selectedTesters = []
    this.selectedSampleDate = []
    this.selectedTest = []
    this.selectedTestStandard = []
    this.selectedArticle = []
    this.selectedArticleNumber = []
    this.selectedOrderNumber = []
    this.selectedBatchNumber = []
    this.selectedSampleNumber = []
  }

  }
};
</script>
  

<style scoped>
.modal {
  display: flex;
  flex-direction: column;
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgba(0, 0, 0, 0.4);
  align-items: center; 
  justify-content: center; 
}
  
.modal-content {
  background-color: #fefefe;
  margin: 15% auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
  height: 80%;
  min-height: 50%;  
  overflow-y: scroll; 
  border-radius: 10px;
}

#app {
  flex: 1;
}

table {
  width: 100%;
  height: 100%;
}
  
.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,

.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}

.dropdown-container {
  position: relative ;
  display: inline-block; 
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  z-index: 10;
  display: none;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border: 1px solid #ccc;
  font-family: 'Arial', sans-serif;
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid black; 
}

.dropdown-container:hover .dropdown-menu {
  display: block;
}

.no-uppercase {
  text-transform: none;
}

.custom-input {
  border: 1px solid black; 
  border-radius: 8px; 
  padding: 3px; 
  width: 100px; 
  height: 30px; 
  box-sizing: border-box; 
}

#filter {
  width: 10px;
  height: 10px;
}

#x {
  width: 15px;
  height: 15px;
}

</style>
  

<!-- 
  const testQuery =  `
  HeaderData = from(bucket: "LabData")
  |> range(start: 0, stop: now())
  |> filter(fn: (r) => r["_measurement"] == "HeaderData")
  |> group(columns: ["_field"])
  |> drop(columns: ["_measurement", "_field", "_value", "_stop_HeaderData"])
  |> sort(columns: ["_time"], desc: true)
  |> limit(n: 2)

  LabData = from(bucket: "LabData")
  |> range(start: 0, stop: now())
  |> filter(fn: (r) => r["_measurement"] == "LabValues")
  |> filter(fn: (r) => r._field == "maximum_stretch_1" or r._field == "maximum_stretch_2" or r._field == "maximum_stretch_3" or r._field == "maximum_stretch_4" or r._field == "maximum_stretch_5" or r._field == "maximum_tensile_force_1" or r._field == "maximum_tensile_force_2" or r._field == "maximum_tensile_force_3" or r._field == "maximum_tensile_force_4" or r._field == "maximum_tensile_force_5")
  |> drop(columns: ["Unit", "_measurement"])
  |> sort(columns: ["_time"], desc: true)
  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
  |> limit(n: 2)

  join(
  tables: {LabData: LabData, HeaderData: HeaderData},
  on: ["_time", "sample_number"]
  )
  |> drop(columns: ["_start_HeaderData", "_start_LabData" , "_stop_HeaderData", "_stop_LabData"])
  `; -->
