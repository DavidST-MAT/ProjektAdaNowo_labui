<template>
  <button type="button" @click="handleButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
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
        labData2: Array,
    },

    // data() {
    //     return {
    //         headerData: []
    //     }
    // },

    methods: {

      handleButtonClick() {
        const currentTime = new Date();
        this.saveHeaderDataToInflux(currentTime);
        this.saveLabValuesToInflux(currentTime);
        this.sendSaveLabValuesToOPC();
        
        this.$emit("button-clicked");
      },


      saveHeaderDataToInflux(currentTime) {

        //console.log(this.headerData)
            
        const writeApi = influxDB.getWriteApi(org, bucket);
        

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


    saveLabValuesToInflux(currentTime){
      console.log('TEST')
      console.log(this.labData)
      console.log('TEST')
      this.labValues = this.labData.concat(this.labData2);
            
      const writeApi = influxDB.getWriteApi(org, bucket);

      for (let i = 0; i < this.labValues.length; i++) {

        const correctedValue = this.labValues[i].Value.replace(',', '.');

        const point = new Point('LabValues')
          .timestamp(currentTime)
          .tag('sample_number', this.sampleNumber)
          .tag('Unit', this.labValues[i].Unit)
          .floatField(this.labValues[i].Parameter, parseFloat(correctedValue))

          
        writeApi.writePoint(point);
              
        writeApi
          .close()
          .then(() => {
             console.log("FINISHED");
          })
          .catch((e) => {
            console.error(e);
            console.log("Finished ERROR");
          });
      }




    },


      // Function to send data to OPCUA-Server via REST-API (fastAPI)
      async sendSaveLabValuesToOPC() {
        //console.log('HI')
        console.log(this.labData)
        console.log(this.labData2)
        this.labValues = this.labData.concat(this.labData2);
        console.log(this.labValues)
        try {
          const response = await axios.post('http://localhost:8000/send_save_LabValues_to_opc', {data: this.labValues});
          //console.log(response.data);
        } catch (error) {
          console.error('Error:', error);
          //console.error('Response data:', error.response.data);
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
 