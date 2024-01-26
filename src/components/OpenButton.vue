<template>
    <div class="header flex">
      <button @click="handleOpenButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">Open</button>
      
      <div v-if="isModalOpen" class="modal">
        <div class="modal-content flex flex-col items-center">
      
          <div id="app" class="relative overflow-x-auto shadow-md sm:rounded-lg">

            
            <div class="flex flex-column sm:flex-row flex-wrap space-y-4 sm:space-y-0 items-center justify-between pb-4">
              <div class="dropdown-container">
                <button @click="toggleDropdown" class="inline-flex items-center text-gray-500 bg-white border border-gray-300 focus:outline-none font-medium rounded-lg text-sm px-3 py-1.5 dark:bg-red-700 dark:text-white" type="button">
                  {{ selectedOption }}
                </button>

                <!-- Dropdown menu -->
                <div v-if="isDropdownVisible" class="dropdown-menu rounded-lg shadow dark:bg-red-200 border">
                  <ul class="text-sm text-black dark:text-black" aria-labelledby="dropdownRadioButton">
                    <li v-for="(option, index) in dropdownOptions" :key="index">
                      <div class="flex items-center p-2 rounded dark:hover:bg-gray-600 dark:hover:bg-gray-600" @click="selectOption(index)">
                        <input :id="'filter-radio-example-' + index" type="radio" :value="option.value" name="filter-radio" :class="option.radioClass">
                        <label :for="'filter-radio-example-' + index" class="w-full ms-2 text-sm font-medium text-white rounded dark:text-black">{{ option.label }}</label>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
              



        <!-- <label for="table-search" class="sr-only">Search</label>
        <div class="relative">
            <div class="absolute inset-y-0 left-0 rtl:inset-r-0 rtl:right-0 flex items-center ps-3 pointer-events-none">
                <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path></svg>
            </div>
            <input type="text" id="table-search" class="block p-2 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg w-80 bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Search for items">
        </div> -->

    </div>
    
    <table class="text-sm text-left rtl:text-right dark:text-black-300">
        <thead class="text-xs text-white-700 uppercase bg-gray-50 dark:bg-red-700 dark:text-white">
            <tr>
                <th v-for="header in headers" :key="header" scope="col" class="px-6 py-3">
          {{ header }}
        </th>
            </tr>
        </thead>
        <tbody>
            <tr class="bg-white border-b dark:bg-white dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 dark:hover:text-white"  v-for="(item, index) in this.data" :key="index" @click="handleRowClick(item)">

                <th scope="row" class="px-6 py-4">
                    {{item.SampleNumber}}
                </th>
                <td class="px-6 py-4">
                    {{item.SampeDate}}
                </td>
                <td class="px-6 py-4">
                    {{item.Tester}}
                </td>
                <td class="px-6 py-4">
                    {{item.Test}}
                </td>
                <td class="px-6 py-4">
                    {{item.TestStandard}}
                </td>
                <td class="px-6 py-4">
                    {{item.Article}}
                </td>
                <td class="px-6 py-4">
                    {{item.ArticleNumber}}
                </td>
                <td class="px-6 py-4">
                    {{item.OrderNumber}}
                </td>
                <td class="px-6 py-4">
                    {{item.BatchNumber}}
                </td>
            </tr>

        </tbody>
    </table>
</div>


          <button @click="closeModal" class="hidden-print mt-4 hover:text-white border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">Close</button>
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
        headers: [
        'Sample number',
        'Sample Date/Time',
        'Tester',
        'Test',
        'Test standard',
        'Article',
        'Article number',
        'Order  number',
        'Batch  number',
        ],
        data: [],
        isModalOpen: false,
        isDropdownVisible: false,
        selectedOption: 'Last 30 days',
      dropdownOptions: [
        { label: 'Last 30 days', value: 'last30Days' },
        { label: 'Last day', value: 'lastDay'},
        { label: 'Last 1 hour', value: 'last1Hour' },
      ],
      };
    },

    methods: {
      handleOpenButtonClick() {
        // Beim Klicken auf den "Open" Button das Modalfenster anzeigen
        this.isModalOpen = true;

        try {
            const fluxQueryHeaderData = `from(bucket: "LabData") 
            |> range(start: 0, stop: now()) 
            |> filter(fn: (r) => r["_measurement"] == "HeaderData") 
            |> group(columns: ["_field"]) 
            |> sort(columns: ["_time"], desc: true) 
            |> limit(n:5)`
          
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
            return result;
          };

            // Execute query and populate data for html table
          myQuery().then((result) => {
            this.data = result
            }
          );

        } catch (error) {
        console.error(error); 
        }

      },




      closeModal() {
        // Methode zum Schließen des Modalfensters
        this.isModalOpen = false;
      },

      handleRowClick(item) {

        const sample_number = item.SampleNumber

        try {
          const fluxQueryLabValues = `from(bucket: "LabData") 
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

    toggleDropdown() {
        this.isDropdownVisible = !this.isDropdownVisible;
      },

      selectOption(index) {
        this.selectedOption = this.dropdownOptions[index].label;
        this.isDropdownVisible = false;
        // Add logic to handle the selected option
        // You can emit an event, make an API call, or perform any other action here
        console.log('Selected option:', this.dropdownOptions[index].value);
      },

    }
  };
  </script>
  
  <style scoped>
  .modal {
    display: block; 
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
    border-radius: 10px;
  }
  
  .modal-content {
    background-color: #fefefe;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    border-radius: 10px;
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
      position: relative;
      display: inline-block;
    }

    .dropdown-menu {
      position: absolute;
      top: 100%;
      left: 0;
      z-index: 10;
      display: none;
    }

    .dropdown-container:hover .dropdown-menu {
      display: block;
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
