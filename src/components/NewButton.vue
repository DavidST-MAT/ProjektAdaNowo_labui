<!-- NewButton.vue -->

<template>
  <button type="button" @click="handleNewButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none font-medium rounded-lg text-sm px-6 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
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
        try {
          const fluxQuery = 'from(bucket: "LabData") |> range(start: 0, stop: now()) |> filter(fn: (r) => r["_measurement"] == "LabValues") |> group(columns: ["_measurement"]) |> last()';

          const myQuery = async () => {
            const result = [];

            for await (const { values, tableMeta } of queryApi.iterateRows(fluxQuery)) {
              const o = tableMeta.toObject(values);
              result.push({ SampleNumber: o.sample_number });
              console.log(result)
            }
            return result;
            };

            // Execute query and populate data for html table
            myQuery().then((result) => {
              if (result.length > 0) {
                this.sampleNumber = result[0].SampleNumber;
                console.log(result[0].SampleNumber)
                console.log('FAV)D')
              } else {
              // Set a default value of 0 if the result array is empty
                this.sampleNumber = 0;
              }

            console.log(this.sampleNumber);
            this.$emit('newButtonClick', this.sampleNumber);
            }
          );

        } catch (error) {
        console.error(error); // Fix the typo here (consol -> console)
        }
      }
    }
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
 