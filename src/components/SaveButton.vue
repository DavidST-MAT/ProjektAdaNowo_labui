<template>
    <button type="button" @click="saveHeaderDataToInflux" class="hidden-print text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      Save
    </button>
  </template>
  
  <script>
    // Import required modules
    const { InfluxDB} = require('@influxdata/influxdb-client');

    // InfluxDB configuration
    const url = "http://localhost:8086"
    const token = "Qc6s7RKI7ZnQpB5ZdesJzEmgd46XLGRmcXv5RJRbhTUc758Ma8g-LQv6_A2p125BZohkhbYnEhVtpeOHJ-BqTw=="
    const org = "MAT"
    const bucket = "LabData"

    const influxDB = new InfluxDB({url, token})

  
  export default {

    props: {
        headerData: Array,
    },

    // data() {
    //     return {
    //         headerData: []
    //     }
    // },

    methods: {

        saveHeaderDataToInflux() {

            console.log(this.headerData)

            // console.log(newRecipeName)
            // console.log(editedList)

            // const writeApi = influxDB.getWriteApi(org, bucket);
            // const currentTime = new Date();

            // for (const dataPoint of editedList) {
            // const { Paramter, Value, Unit} = dataPoint;

            // const point = new Point('Recipe')
            //     .timestamp(currentTime)
            //     .tag('recipe', newRecipeName)
            //     .tag('Unit', Unit)
            //     .floatField(Paramter, Value)

            // writeApi.writePoint(point);
            // }

            // writeApi
            // .close()
            // .then(() => {
            //     console.log("FINISHED");
            // })
            // .catch((e) => {
            //     console.error(e);
            //     console.log("Finished ERROR");
            // });
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
 