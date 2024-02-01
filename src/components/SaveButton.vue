<template>
  <button type="button" @click="handleButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">
    Save
  </button>
    <!-- Error Modal -->
    <div v-if="showErrorModal" class="error-modal">
      <div class="modal-content">
        <span class="close" @click="showErrorModal = false">&times;</span>
        <p>Error: {{errorValue}} is not a valid number.</p>
      </div>
    </div>
</template>
  

<script>
import axios from 'axios';

const { InfluxDB, Point} = require('@influxdata/influxdb-client');
const url = process.env.VUE_APP_INFLUX_URL;
const token = process.env.VUE_APP_INFLUX_TOKEN;
const org = process.env.VUE_APP_INFLUX_ORG;
const bucket = "LabData"

const influxDB = new InfluxDB({url, token})


export default {

  emits: ['buttonClicked'],


  props: {
      headerData: Array,
      sampleNumber: Number,
      labDataTable: Array,
  },

  data() {
      return {
          showErrorModal: false,
          errorValue: '',
      };
  },



  methods: {

    handleButtonClick() {
      const currentTime = new Date();
      
      const labValuesSaved = this.saveLabValuesToInflux(currentTime);
      const labValuesSent =  this.sendSaveLabValuesToOPC();
      
      
        
        if (labValuesSaved && labValuesSent) {
          console.log("Save Button succeeded");
        } else {
          console.error("Ein oder mehrere Funktionen waren nicht erfolgreich.");
        }
      }, 



    // Function to send HeaderData to Influx via Influx-Client
    saveHeaderDataToInflux(currentTime) {
          
      const writeApi = influxDB.getWriteApi(org, bucket);
      
      const point = new Point('HeaderData')
        .timestamp(currentTime)
        .tag('Sample_Date', this.headerData[0].Value)
        .tag('Tester', this.headerData[1].Value)
        .tag('Test', this.headerData[2].Value)
        .tag('Test_Standard', this.headerData[3].Value)
        .tag('Article', this.headerData[4].Value)
        .tag('Article_Number', this.headerData[5].Value)
        .tag('Order_Number', this.headerData[6].Value)
        .tag('Batch_Number', this.headerData[7].Value)
        .tag('Comment', this.headerData[8].Value)
        .tag('sample_number', this.sampleNumber)
        .intField('sample_number', this.sampleNumber)

      console.log(`Saving HeaderData: ${point}`)
      
      writeApi.writePoint(point);
          
      writeApi
      .close()
      .then(() => {
          console.log("Saved HeaderData for LabUI to Influx");
          return true
      })
      .catch((e) => {
          console.error(e);
          console.log("ERROR while saving HeaderData");
          return false
      });

      this.$emit('buttonClicked')
    },


    // Function to send labValues to Influx via Influx-Client
    saveLabValuesToInflux(currentTime){
      console.log(this.labDataTable)

      const labDataTable = {};

      for (const item of this.labDataTable) {
        const rowNumber = item.row;
        
        labDataTable[`maximum_tensile_force_md_${rowNumber}`] = item.maximum_tensile_force_md_;
        labDataTable[`maximum_tensile_force_cd_${rowNumber}`] = item.maximum_tensile_force_cd_;
        labDataTable[`maximum_stretch_md_${rowNumber}`] = item.maximum_stretch_md_;
        labDataTable[`maximum_stretch_cd_${rowNumber}`] = item.maximum_stretch_cd_;
      }

      console.log(labDataTable);

      for (const key in labDataTable) {
        console.log(`${key}: ${labDataTable[key]}`);
        const correctedValue = labDataTable[key].replace(',', '.');
        console.log(correctedValue);
        if (isNaN(correctedValue)) {
          console.error(`saveLabValuesToInflux Error: ${correctedValue} is not a valid number.`);
          this.errorValue = correctedValue;
          this.showErrorModal = true; 
          return false; 
        }
      }

      const writeApi = influxDB.getWriteApi(org, bucket);

      // If all inputs are valid => send to Influx
      for (const key in labDataTable){

        if (labDataTable[key] === '') {
        continue;
        }

        const floatValue = labDataTable[key].replace(',', '.')
        if (key.includes("stretch"))
        {
          var unit = '%'
        } else if (key.includes("force")) {
          var unit = 'N'
        } else {
            console.log("No Unit is set");
        }

        const point = new Point('LabValues')
          .timestamp(currentTime)
          .tag('sample_number', this.sampleNumber)
          .tag('Unit', unit)
          .floatField(key, parseFloat(floatValue))

          console.log(`Saving LabValues: ${point}`)
          writeApi.writePoint(point);
                
          writeApi
            .close()
            .then(() => {
              console.log("Saved LabValues for LabUI to Influx");
            })
            .catch((e) => {
              console.error(e);
              console.log("ERROR while saving LabValues");
              return false
            });
      }
      this.saveHeaderDataToInflux(currentTime);
      return true
      
    },


    // Function to send labValues to OPCUA-Server via REST-API (fastAPI)
    async sendSaveLabValuesToOPC() {
      const labDataTable = {};
      console.log(labDataTable)

      for (const item of this.labDataTable) {
        const rowNumber = item.row;
        
        labDataTable[`maximum_tensile_force_md_${rowNumber}`] = item.maximum_tensile_force_md_;
        labDataTable[`maximum_tensile_force_cd_${rowNumber}`] = item.maximum_tensile_force_cd_;
      }

      console.log(labDataTable);

      for (const key in labDataTable) {
        
          const correctedValue = labDataTable[key].replace(',', '.');
        
        if (isNaN(correctedValue)) {
          console.error(`saveLabValuesToInflux Error: ${correctedValue} is not a valid number.`);
          return false; 
        }
      }

      try {
        console.log(`LabValues Save-Button to OPC: ${labDataTable}`)
        // Send Data to FastAPI
        const response = await axios.post('http://localhost:8000/send_save_LabValues_to_opc', {data: labDataTable});
        return true
      } catch (error) {
        console.error('Error:', error);
        return false
      }
    },


  },

}
</script>
  
<style scoped>

.error-modal {
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
  background-color: #fefefe;
  padding: 20px;
  border: 1px solid #888;
}

.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
  cursor: pointer;
}

.close:hover,

.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}

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
