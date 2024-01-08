<template>
  <button type="button" @click="handleButtonClick" class="hidden-print text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
    Save
  </button>
</template>
  
  <script>
    import axios from 'axios';

    // InfluxDB configuration
    const { InfluxDB, Point} = require('@influxdata/influxdb-client');
    const url = "http://localhost:8086"
    const token = "Qc6s7RKI7ZnQpB5ZdesJzEmgd46XLGRmcXv5RJRbhTUc758Ma8g-LQv6_A2p125BZohkhbYnEhVtpeOHJ-BqTw=="
    const org = "MAT"
    const bucket = "LabData"

    const influxDB = new InfluxDB({url, token})

  
  export default {

    props: {
        headerData: Array,
        sampleNumber: Number,
        labData: Array,
    },

    // data() {
    //     return {
    //         headerData: []
    //     }
    // },

    methods: {

      handleButtonClick() {
        this.saveHeaderDataToInflux();
        this.saveLabValesToOPC();
        this.$emit("button-clicked");
      },

      saveHeaderDataToInflux() {

        console.log(this.headerData)
            
        const writeApi = influxDB.getWriteApi(org, bucket);
        const currentTime = new Date();

        const point = new Point('HeaderData')
          .timestamp(currentTime)
          .tag('Tester', this.headerData[1].Value)
          .tag('Test', this.headerData[2].Value)
          .tag('Test_Standard', this.headerData[3].Value)
          .tag('Article', this.headerData[4].Value)
          .tag('Article_Number', this.headerData[5].Value)
          .tag('Order_Number', this.headerData[6].Value)
          .tag('Batch_Number', this.headerData[7].Value)
          .tag('Comment', this.headerData[8].Value)
          .intField('sample_number', this.sampleNumber)

        console.log(point)

        // writeApi.writePoint(point);
            
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


              // Function to send data to OPCUA-Server via REST-API (fastAPI)
      async saveLabValesToOPC() {
        console.log('HI')
        console.log(this.labData)
        try {
          const response = await axios.post('http://localhost:8000/send_labData_to_opcua', {data: this.labData});
          //console.log(response.data);
        } catch (error) {
          console.error('Error:', error);
          console.error('Response data:', error.response.data);
        }
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
 