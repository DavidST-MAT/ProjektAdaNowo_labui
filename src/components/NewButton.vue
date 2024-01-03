<!-- NewButton.vue -->

<template>
    <button type="button" @click="handleNewButtonClick" class="hidden-print mt-4 text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      New
    </button>
  </template>
  
  <script>
    // Import required modules
    const { InfluxDB} = require('@influxdata/influxdb-client');


    // InfluxDB configuration
    const url = "http://localhost:8086"
    const token = "Qc6s7RKI7ZnQpB5ZdesJzEmgd46XLGRmcXv5RJRbhTUc758Ma8g-LQv6_A2p125BZohkhbYnEhVtpeOHJ-BqTw=="
    const org = "MAT"
    const queryApi = new InfluxDB({url, token}).getQueryApi(org)

  
  export default {
    methods: {
      async handleNewButtonClick() {
        const fluxQuery = 'from(bucket: "LabData") |> range(start: 0, stop: now()) |> filter(fn: (r) => r["_measurement"] == "LabValues") |> group(columns: ["_field"]) |> last()'
        const myQuery = async () => {
        const result = []
         
        for await (const {values, tableMeta} of queryApi.iterateRows(fluxQuery)) {
          const o = tableMeta.toObject(values)
          result.push({SampleNumber: o._value})
        }
        console.log(result)
        return result
      }

      // Execute query and populate data for html table
      myQuery().then(result => {
        this.sampleNumber = result[0].SampleNumber
        console.log(this.sampleNumber)
        this.$emit('newButtonClick', this.sampleNumber);
      })
      },
    },
  };
  </script>
  
  <style scoped>
  /* Add any styles specific to the NewButton component if needed */
  @media print {
  .hidden-print {
    display: none !important;
  }

  @page {
    size: auto;   /* auto is the default value */
    margin: 0mm;  /* zero out the margins */
  }

  body::after {
    content: none !important;
  }

  header, footer {
    display: none;
  }
}
  </style>
  