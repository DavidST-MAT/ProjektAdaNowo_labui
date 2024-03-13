<template>
  <!-- Modal container -->
  <div class="modal">
    <div class="modal-content flex flex-col items-center">
      <h2 class="sample-number-heading">{{ headerNew }}</h2>
      <h3 class="sample-number-heading"> {{ sampleNumber }} </h3>

      <!-- Header Buttons -->
      <div class="header flex">
        <NewButton @newButtonClick="handleNewButtonClick" />
        <OpenButton @openButtonClick="handleOpenButtonClick" @row-clicked="handleRowClick"/>
      </div>

      <!-- Display Table if New or Open Button Clicked -->
      <template v-if="isNewButtonClicked || isOpenButtonClicked">
      
        <table  class="sizeme1 mx-auto my-4 border border-slate-200 text-sm text-left text-gray-100 bg-gray-100 border-black mt-100 ">
          <tbody id="labUIdata">

            <!-- Iterate over headerData for table -->
            <tr class="border-b bg-gray-100 border-black" v-for="(item, index) in this.headerData" :key="index">
              <th scope="row" class="sizemeTD px-6 py-4 font-medium text-gray-900 whitespace-nowrap text-black">
                {{ item.Parameter }} <!-- Display Parameter Name -->
              </th>

              <td class="sizemeTD px-6 py-4 text-black">

                <!-- Input or Display Value based on New/Open Button Click -->
                <template v-if="item.Parameter === 'Tester'">
                  <template v-if="isNewButtonClicked">
                    <TesterInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Test'">
                  <template v-if="isNewButtonClicked">
                    <TestInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Test standard'">
                  <template v-if="isNewButtonClicked">
                    <TestStandardInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Article'">
                  <template v-if="isNewButtonClicked">
                    <ArticleInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Article number'">
                  <template v-if="isNewButtonClicked">
                    <ArticleNumberInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Order number'">
                  <template v-if="isNewButtonClicked">
                    <OrderInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Batch number'">
                  <template v-if="isNewButtonClicked">
                    <BatchInput @input-change="handleInputChange"/>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle">{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else-if="item.Parameter === 'Comment'">
                  <template v-if="isNewButtonClicked">
                    <textarea v-model.lazy="item.Value" rows="3" cols="22" class="custom-input"> </textarea>
                  </template>
                  <template v-else-if="isOpenButtonClicked">
                    <div class="text-center align-middle" >{{ item.Value }}</div>
                  </template>
                </template>

                <template v-else>
                  <div class="text-center align-middle">{{ item.Value }}</div>
                </template>

              </td>

            </tr>

          </tbody>    
        </table>

        <!-- Table for Lab Data -->
        <div class="sizeme relative flex-grow sm:rounded-lg">

          <table class="sizeme mx-auto my-4 border border-slate-100 text-sm text-left bg-gray-100 text-gray-100 mt-100 equal-height-table border-black">

            <!-- Table Headers -->
            <thead class="sizemeTD text-xs text-gray-700 uppercase bg-red-700 text-white">
              <tr class="sizemeTD text-center align-middle">
                <th v-for="header in headers" :key="header" scope="col" class="px-6 py-3 sizemeTD">
                  {{ header }}
                </th>
              </tr>
            </thead>

            <tbody>
              <!-- Rows for Lab Data -->
              <tr class="sizemeTD border-b bg-gray-100 border-black" v-for="(item, index) in this.labDataTable" :key="index">

                <th scope="row" class="font-medium text-gray-900 text-black text-center align-middle" style="width: 15%;">
                  {{ item.row }}
                </th>
    
                <!--Rows and columns with input-field and set button-->
                <td class="sizemeTD px-6 py-4 text-black">
                  <div class="flex rounded-md overflow-hidden w-full">
                    <template v-if="isNewButtonClicked">
                      <input v-model="item.TensileStrength_" type="text" class="custom-input2" />
                    </template>
                  </div>
                  <template v-if="isOpenButtonClicked">
                    <div class="flex items-center justify-center">{{ item.TensileStrength_ }}</div>
                  </template>  
                </td>

                <td class="px-6 py-4 text-black">
                  <div class="flex rounded-md overflow-hidden w-full">
                    <template v-if="isNewButtonClicked">
                      <input v-model="item.TearLength_" type="text" class="custom-input2" />
                    </template>
                  </div>
                  <template v-if="isOpenButtonClicked">
                    <div class="flex items-center justify-center">{{ item.TearLength_ }}</div>
                  </template>  
                </td>

              </tr>

            </tbody>

          </table>

          

        </div>


                <!-- Table for Lab Data -->
                <div class="sizeme relative flex-grow sm:rounded-lg">

                  <table class="sizeme mx-auto my-4 border border-slate-100 text-sm text-left bg-gray-100 text-gray-100 mt-100 equal-height-table border-black">

                    <!-- Table Headers -->
                    <thead class="sizemeTD text-xs text-gray-700 uppercase bg-red-700 text-white">
                      <tr class="sizemeTD text-center align-middle">
                        <th v-for="header in headers2" :key="header" scope="col" class="px-6 py-3 sizemeTD">
                          {{ header }}
                        </th>
                      </tr>
                    </thead>

                    <tbody>
                      <!-- Rows for Lab Data -->
                      <tr class="sizemeTD border-b bg-gray-100 border-black" v-for="(item, index) in this.labDataTable2" :key="index">

                        <th scope="row" class="font-medium text-gray-900 text-black text-center align-middle" style="width: 15%;">
                          {{ item.row }}
                        </th>

                        <!--Rows and columns with input-field and set button-->
                        <td class="sizemeTD px-6 py-4 text-black">
                          <div class="flex rounded-md overflow-hidden w-full">
                            <template v-if="isNewButtonClicked">
                              <input v-model="item.AreaWeight_" type="text" class="custom-input2" />

                            </template>
                          </div>
                          <template v-if="isOpenButtonClicked">
                            <div class="flex items-center justify-center">{{ item.AreaWeight_ }}</div>
                          </template>  
                        </td>
                      </tr>

                    </tbody>

                  </table>

                </div>

        <!-- Buttons Container -->
        <div class="buttons-container flex justify-end mt-4">
          <template v-if="isNewButtonClicked">
            <SaveButton :headerData="headerData" :sampleNumber="sampleNumber" :labDataTable="labDataTable" :labDataTable2="labDataTable2" @button-clicked="handleSaveButtonClick"/>
          </template>
          <PrintButton/>
        </div>

      </template>

    </div>
  </div>

</template>
  

<script>
// Importing Vue Components
import NewButton from './NewButton.vue';
import OpenButton from './OpenButton.vue';
import PrintButton from './PrintButton.vue';
import ArticleInput from './ArticleInput.vue';
import TesterInput from './TesterInput.vue';
import BatchInput from './BatchInput.vue';
import OrderInput from './OrderInput.vue';
import ArticleNumberInput from './ArticleNumberInput.vue';
import SaveButton from './SaveButton.vue';
import SetButton from './SetButton.vue';
import TestInput from './TestInput.vue';
import TestStandardInput from './TestStandardInput.vue';



export default {
  props: {
    show: Boolean,
  },


  data() {
    return {
      isNewButtonClicked: false,
      isOpenButtonClicked: false,
      headerNew: 'Laboratory testing',
      sampleNumber: '',
      currentValue: '',
      testerName: '',
      suggest: '',
      labValue: '',
      headers: [
        'Sub Sample',
        'Tensile Strength [Fmax]',
        'Tear Length [%]',
      ],
      headers2: [
        'Sub Sample',
        'Area Weight[g/m^2]',
      ],
      tensileHeader: 'TensileStrength_',
      tearHeader: 'TearLength_',
      areaWeight: 'AreaWeightLane',
      headerData: [
        { Parameter: 'Sample Date/Time', Value: '' },
        { Parameter: 'Tester', Value: '' },
        { Parameter: 'Test', Value: '' },
        { Parameter: 'Test standard', Value: '' },
        { Parameter: 'Article', Value: '' },
        { Parameter: 'Article number', Value: '' },
        { Parameter: 'Order number', Value: '' },
        { Parameter: 'Batch number', Value: '' },
        { Parameter: 'Comment', Value: '' },
      ],
      labDataTable: [
        { row: 'MD1', TensileStrength_: '', TearLength_: ''},
        { row: 'MD2', TensileStrength_: '', TearLength_: ''},
        { row: 'MD3', TensileStrength_: '', TearLength_: ''},
        { row: 'MD4', TensileStrength_: '', TearLength_: ''},
        { row: 'MD5', TensileStrength_: '', TearLength_: ''},
        { row: 'CD1', TensileStrength_: '', TearLength_: ''},
        { row: 'CD2', TensileStrength_: '', TearLength_: ''},
        { row: 'CD3', TensileStrength_: '', TearLength_: ''},
        { row: 'CD4', TensileStrength_: '', TearLength_: ''},
        { row: 'CD5', TensileStrength_: '', TearLength_: ''}
      ],
      labDataTable2: [
        { row: 'AW1', AreaWeight_: ''},
        { row: 'AW2', AreaWeight_: ''},
        { row: 'AW3', AreaWeight_: ''}
      ],
    };
  },
  

  methods: {

    // Handling input change for different parameters and updating the value in the headerData array
    handleInputChange(paramterName, value) {
      this.headerData.find(item => item.Parameter === paramterName).Value = value;
    },

    // Handling Open Button Click
    handleOpenButtonClick() {
      this.isOpenButtonClicked = true;
    },

    // Event handler for when a row is clicked in Open-Modal
    handleRowClick(item, labValues) {
      this.isOpenButtonClicked = true;
      this.isNewButtonClicked = false;

      // Log details of the clicked row and associated lab values
      console.log('Row clicked:', item);
      console.log('Row clicked:', labValues);

      // Update headerData based on the clicked row values
      for (let i = 0; i < this.headerData.length; i++) {
        // Check each parameter in headerData and update its value based on the clicked row's data
        if (this.headerData[i].Parameter === 'Sample Date/Time') {
          this.headerData[i].Value = item.SampeDate; 
        } else if (this.headerData[i].Parameter === 'Tester') {
            this.headerData[i].Value = item.Tester;
        } else if (this.headerData[i].Parameter === 'Test') {
            this.headerData[i].Value = item.Test;
        } else if (this.headerData[i].Parameter === 'Test standard') {
            this.headerData[i].Value = item.TestStandard;
        } else if (this.headerData[i].Parameter === 'Article') {
            this.headerData[i].Value = item.Article;
        } else if (this.headerData[i].Parameter === 'Article number') {
            this.headerData[i].Value = item.ArticleNumber;
        } else if (this.headerData[i].Parameter === 'Order number') {
            this.headerData[i].Value = item.OrderNumber;
        } else if (this.headerData[i].Parameter === 'Batch number') {
            this.headerData[i].Value = item.BatchNumber;
          } else if (this.headerData[i].Parameter === 'Comment') {
            if (item.Comment !== undefined) {
                this.headerData[i].Value = item.Comment.replace('\\n', '\n');
            } else {
                this.headerData[i].Value = '';
            }
        }

      }


      // Update labDataTable based on the labValues associated with the clicked row
      this.labDataTable.forEach((row, index) => {
        const tensileStrengthParameter = `TensileStrength_${this.labDataTable[index].row}`;
        const tearLengthParameter = `TearLength_${this.labDataTable[index].row}`;
        console.log(tensileStrengthParameter)
        console.log(row)
        console.log(index)
        console.log(this.labDataTable)
        // Find corresponding values in labValues array and update the labDataTable
        const tensileStrengthValue = String(labValues.find(item => item.Parameter === tensileStrengthParameter)?.Value || '');
        const tearLengthValue = String(labValues.find(item => item.Parameter === tearLengthParameter)?.Value || '');

        // Update the values in the labDataTable row
        row.TensileStrength_ = tensileStrengthValue;
        row.TearLength_ = tearLengthValue;
      });

      // Update labDataTable based on the labValues associated with the clicked row
      this.labDataTable2.forEach((row, index) => {
        const areaWeight  = `AreaWeight_AW${index + 1}`;
        // Find corresponding values in labValues array and update the labDataTable
        const areaWeightValue = String(labValues.find(item => item.Parameter === areaWeight)?.Value || '');

        // Update the values in the labDataTable row
        row.AreaWeight_ = areaWeightValue;
      });

      // Set sampleNumber and headerNew based on the clicked row's SampleNumber
      this.sampleNumber = item.SampleNumber
      this.headerNew = 'SAMPLE NUMBER';
    },


    // Function for clicking button "New", gets called from NewButton.vue 
    handleNewButtonClick(result) {
      this.isNewButtonClicked = true;
      this.isOpenButtonClicked = false;

      // Set the default values for "labDataTable", needs to be assigned again if array is populated
      this.labDataTable = [
        { row: 'MD1', TensileStrength_: '', TearLength_: ''},
        { row: 'MD2', TensileStrength_: '', TearLength_: ''},
        { row: 'MD3', TensileStrength_: '', TearLength_: ''},
        { row: 'MD4', TensileStrength_: '', TearLength_: ''},
        { row: 'MD5', TensileStrength_: '', TearLength_: ''},
        { row: 'CD1', TensileStrength_: '', TearLength_: ''},
        { row: 'CD2', TensileStrength_: '', TearLength_: ''},
        { row: 'CD3', TensileStrength_: '', TearLength_: ''},
        { row: 'CD4', TensileStrength_: '', TearLength_: ''},
        { row: 'CD5', TensileStrength_: '', TearLength_: ''}
      ];

      this.labDataTable2 = [
        { row: 'AW1', AreaWeight_: ''},
        { row: 'AW2', AreaWeight_: ''},
        { row: 'AW3', AreaWeight_: ''}
      ];

      var commentEntry = this.headerData.find(item => item.Parameter === 'Comment');
      commentEntry.Value = '';
      
      // Set date for "Sample Date/Time"
      const currentDate = new Date();
      const formattedDate = currentDate.toLocaleString(); 

      const probeDateTimeItem = this.headerData.find(item => item.Parameter === 'Sample Date/Time');
      if (probeDateTimeItem) {
        probeDateTimeItem.Value = formattedDate;
      }

      // Increment the sample number for new sample number
      this.sampleNumber = result
      this.sampleNumber++

      // Switch header
      this.headerNew = 'SAMPLE NUMBER';
    },

    // Disable New and Open Modal
    handleSaveButtonClick() {
      this.isNewButtonClicked = false;
      this.isOpenButtonClicked = false;
    },

    // Parent function for SetButton.vue. Getting the index of Set Button and disbale InputField
    disableInput(type, index) {
      this.labDataTable[index][`${type}Disabled`] = true;
    },

    isInputDisabled(item) {
      return item.isInputDisabled || false;
    },

  },

  components: {
    NewButton,
    OpenButton,
    PrintButton,
    TesterInput,
    ArticleInput,
    BatchInput,
    OrderInput,
    ArticleNumberInput,
    SaveButton,
    SetButton,
    TestInput,
    TestStandardInput
  },

};
</script>
  


<style>

.sample-number-heading {
  font-size: 20px; 
  font-weight: bold; 
}

.modal-content {
  border: none;
}

.custom-input {
  border: 1px solid black; 
  border-radius: 8px; 
  padding: 4px 8px; 
}
  
.custom-input2 {
  border: 1px solid black;
  border-radius: 8px; 
  padding: 3px 8px; 
}

.custom-input3 {
  border: 1px solid black;
  border-radius: 8px; 
  padding: 3px 8px;
}

.buttons-container {
  display: flex;
  justify-content: center;
  margin-top: 10px; 
  margin-left: 30px;
}

.btn {
  border: 1px solid #4a5568; 
  background-color: #2d3748; 

  padding: 0.5rem 1rem; 
  border-radius: 0.25rem;
  cursor: pointer;
}

.btn:hover {
  background-color: #1a202c; 
}

input {
  text-align: center;
}

.center {
  text-align: center;
  align-items: center;
}



.flex {
  display: flex;
}

.equal-height-table {
  flex-grow: 1;
  min-width: 0;
}

.table-container {
  margin: 0 10px; 
}

@media print {
  body {
      margin: 0; 
    }


  .hidden-print {
    display: none !important;
  }

  a[href]:after {
    content: none !important;
  }

  header, footer {
    display: none;
  }

  .sizeme1 {
    width: 50% !important; 
      margin: auto !important; 
      border-collapse: collapse !important;
      font-size: 7px !important; 
    }

    .sizeme {
    width: 70% !important; 
      margin: auto !important; 
      border-collapse: collapse !important;
      font-size: 7px !important; 
    }

    .sizemeTD {
      font-size: 7px !important;
    }

    th, td {
    font-size: 8px !important;
  }

  th, td {
    padding: 0.5px !important;; 
  }

  .custom-input2 {
    padding: 2px 1px 1px 2px !important;
  }
  

  .sample-number-heading {
    font-size: 12px;
  }

  .header {
    font-size: 5px; 
  }

  @media print {
    .custom-input {
      border: none;
    }
  }
}

</style>
