<!-- NewButton.vue -->

<template>
  <button type="button" @click="handleNewButtonClick" class="hidden-print mt-4 hover:text-dark border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-6 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">
    New
  </button>
</template>
  
<script>
// Import required modules
const { InfluxDB} = require('@influxdata/influxdb-client');

// InfluxDB configuration
const url = process.env.VUE_APP_INFLUX_URL;
const token = process.env.VUE_APP_INFLUX_TOKEN;
const org = process.env.VUE_APP_INFLUX_ORG;
const queryApi = new InfluxDB({url, token}).getQueryApi(org)


export default {

    methods: {

    // Getting the last sample number from InfluxDB and sending it to parent-function
    async handleNewButtonClick() {
      try {
        // Query for last database entry
        const fluxQuery = `from(bucket: "LabData") 
          |> range(start: 0, stop: now()) 
          |> filter(fn: (r) => r["_measurement"] == "LabValues") 
          |> group(columns: ["_measurement"]) |> last()`;

        const myQuery = async () => {
          const result = [];

          for await (const { values, tableMeta } of queryApi.iterateRows(fluxQuery)) {
            const o = tableMeta.toObject(values);
            result.push({ SampleNumber: o.sample_number });
          }
          return result;
          };

          // Call the asynchronous function and then proceed..
          myQuery().then((result) => {
            if (result.length > 0) {
              // If the result array contains elements, assign the SampleNumber from the first element to "this.sampleNumber"
              this.sampleNumber = result[0].SampleNumber;
              console.log(result[0].SampleNumber)
            } else {
              // Set a default value of 0 if the result array is empty
              this.sampleNumber = 0;
            }

          // Trigger a custom event 'newButtonClick' in parent component and pass "this.sampleNumber" as a data parameter
          this.$emit('newButtonClick', this.sampleNumber);
          }
        )

      } catch (error) {
      console.error(error)
      }
    }
  }
};

</script>

<style scoped>
@media print {
  .hidden-print {
    display: none !important;
  }

  @page {
    size: auto;   
    margin: 0mm;  
  }

  body::after {
    content: none !important;
  }

  header, footer {
    display: none;
  }
}
</style>
 