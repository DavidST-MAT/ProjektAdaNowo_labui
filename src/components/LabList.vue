<template>
  <div class="modal">
    <div class="modal-content flex flex-col items-center">

      <h2 class="sample-number-heading">{{ headerNew }}</h2>
      <h3 class="sample-number-heading"> {{ sampleNumber }} </h3> 
      <div class="header flex">
        <NewButton @newButtonClick="handleNewButtonClick" />
        <OpenButton @openButtonClick="handleOpenButtonClick" @row-clicked="handleRowClick"/>
      </div>

      <template v-if="isNewButtonClicked || isOpenButtonClicked">
      
        <table  class="mx-auto my-4 border border-slate-200 text-sm text-left dark:bg-gray-100 dark:border-black text-gray-100 dark:text-white mt-100">
          <tbody id="labUIdata">
            <tr class="bg-white border-b dark:bg-gray-100 dark:border-black" v-for="(item, index) in this.headerData" :key="index">
              <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black">
                {{ item.Parameter }}
              </th>
              <td class="px-6 py-4 dark:text-black">

   

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
                    <textarea v-model.lazy="item.Value" rows="3" cols="22" class="custom-input"></textarea>
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

        <div class="relative overflow-x-auto  sm:rounded-lg">
  <table class="test mx-auto my-4 border border-slate-100 text-sm text-left dark:bg-gray-100 dark:text-gray-100 mt-100 equal-height-table dark:border-black">

    <thead class="text-xs text-gray-700 uppercase dark:bg-red-700 dark:text-white">
      <tr class="text-center align-middle">
        <th v-for="header in headers" :key="header" scope="col" class="px-6 py-3">
          {{ header }}
        </th>
      </tr>
    </thead>

    <tbody>

      <tr class="bg-white border-b dark:bg-gray-100 dark:border-black" v-for="(item, index) in this.labDataTable" :key="index">

        <th scope="row" class="font-medium text-gray-900 dark:text-black text-center align-middle" style="width: 15%;">
          {{ item.row }}
        </th>

        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden w-full">
            <template v-if="isNewButtonClicked">
              <input v-model="item.maximum_tensile_force_md_" :disabled="item.tensileMDDisabled" type="text" class="custom-input2" />
              <SetButton :row="item.row" :labValue="item.maximum_tensile_force_md_" :parameterHeader="tensileHeaderMD" @disable-input="disableInput('tensileMD', index)" />
            </template>
          </div>
          <template v-if="isOpenButtonClicked">
            <div class="flex items-center justify-center">{{ item.maximum_tensile_force_md_ }}</div>
          </template>  
        </td>

        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden w-full">
            <template v-if="isNewButtonClicked">
              <input v-model="item.maximum_tensile_force_cd_" :disabled="item.tensileCDDisabled" type="text" class="custom-input2" />
              <SetButton :row="item.row" :labValue="item.maximum_tensile_force_cd_" :parameterHeader="tensileHeaderCD" @disable-input="disableInput('tensileCD', index)" />
            </template>
          </div>
          <template v-if="isOpenButtonClicked">
            <div class="flex items-center justify-center">{{ item.maximum_tensile_force_cd_ }}</div>
          </template>  
        </td>

        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden">
            <template v-if="isNewButtonClicked">
              <input v-model="item.maximum_stretch_md_" :disabled="item.stretchMDDisabled" type="text" class="custom-input2" />
              <SetButton :row="item.row" :labValue="item.maximum_stretch_md_" :parameterHeader="stretchHeaderMD" @disable-input="disableInput('stretchMD', index)" /> 
            </template>
          </div>
          <template v-if="isOpenButtonClicked">
            <div class="flex items-center justify-center">{{ item.maximum_stretch_md_ }}</div>
          </template>   
        </td>

        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden">
            <template v-if="isNewButtonClicked">
              <input v-model="item.maximum_stretch_cd_" :disabled="item.stretchCDDisabled" type="text" class="custom-input2" />
              <SetButton :row="item.row" :labValue="item.maximum_stretch_cd_" :parameterHeader="stretchHeaderCD" @disable-input="disableInput('stretchCD', index)" />
            </template>
          </div>
          <template v-if="isOpenButtonClicked">
            <div class="flex items-center justify-center">{{ item.maximum_stretch_cd_ }}</div>
          </template>   
        </td>

      </tr>

    </tbody>

  </table>
</div>


        <div class="buttons-container flex justify-end mt-4">
          <template v-if="isNewButtonClicked">
            <SaveButton :headerData="headerData" :sampleNumber="sampleNumber" :labDataTable="labDataTable" @button-clicked="handleSaveButtonClick"/>
          </template>
          <PrintButton/>
        </div>

      </template>

    </div>
  </div>

</template>
  

<script>
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
        'Maximum Tensile Force MD [N]',
        'Maximum Tensile Force CD [N]',
        'Maximum Stretch MD [%]',
        'Maximum Stretch CD [%]'
        ],
      tensileHeaderMD: 'maximum_tensile_force_md_',
      tensileHeaderCD: 'maximum_tensile_force_cd_',
      stretchHeaderMD: 'maximum_stretch_md_',
      stretchHeaderCD: 'maximum_stretch_cd_',
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
        { row: '1', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '2', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '3', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '4', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '5', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
      ],
    };
  },
  

  methods: {

    handleInputChange(paramterName, value) {
      this.headerData.find(item => item.Parameter === paramterName).Value = value;
    },

    handleOpenButtonClick() {
      this.isOpenButtonClicked = true;
    },

    handleRowClick(item, labValues) {
      this.isOpenButtonClicked = true;
      this.isNewButtonClicked = false;

      console.log('Row clicked:', item);
      console.log('Row clicked:', labValues);

      for (let i = 0; i < this.headerData.length; i++) {
        if (this.headerData[i].Parameter === 'Sample Date/Time') {
          this.headerData[i].Value = item.SampeDate; 
          console.log(item.SampeDate)
        } else if (this.headerData[i].Parameter === 'Tester') {
          this.headerData[i].Value = item.Tester;
        } 
          else if (this.headerData[i].Parameter === 'Test') {
          this.headerData[i].Value = item.Test;
        } 
          else if (this.headerData[i].Parameter === 'Test standard') {
          this.headerData[i].Value = item.TestStandard;
        } 
          else if (this.headerData[i].Parameter === 'Article') {
            this.headerData[i].Value = item.Article;
          } 
          else if (this.headerData[i].Parameter === 'Article number') {
            this.headerData[i].Value = item.ArticleNumber;
          } 
          else if (this.headerData[i].Parameter === 'Order number') {
            this.headerData[i].Value = item.OrderNumber;
          } 
          else if (this.headerData[i].Parameter === 'Batch number') {
            this.headerData[i].Value = item.BatchNumber;
          }
          else if (this.headerData[i].Parameter === 'Comment') {
            this.headerData[i].Value = item.Comment;
            this.headerData[i].Value= this.headerData[i].Value.replace('\\n', '\n')
          }
          else if (this.headerData[i].Parameter === 'Comment') {
            this.headerData[i].Value = item.Comment;
            this.headerData[i].Value= this.headerData[i].Value.replace('\\n', '\n')
          }  
      }

      console.log(this.labDataTable);

      this.labDataTable.forEach((row, index) => {
        const stretchParameterMD = `maximum_stretch_md_${index + 1}`;
        const stretchParameterCD = `maximum_stretch_cd_${index + 1}`;
        const tensileForceParameterMD = `maximum_tensile_force_md_${index + 1}`;
        const tensileForceParameterCD = `maximum_tensile_force_cd_${index + 1}`;

        // Finde die entsprechenden Werte im dataFromAPI-Array
        const stretchValueMD = String(labValues.find(item => item.Parameter === stretchParameterMD)?.Value || '');
        const stretchValueCD = String(labValues.find(item => item.Parameter === stretchParameterCD)?.Value || '');
        const tensileForceValueMD = String(labValues.find(item => item.Parameter === tensileForceParameterMD)?.Value || '');
        const tensileForceValueCD = String(labValues.find(item => item.Parameter === tensileForceParameterCD)?.Value || '');

        // Aktualisiere die Werte direkt im labDataTable-Array
        row.maximum_stretch_md_ = stretchValueMD;
        row.maximum_stretch_cd_ = stretchValueCD;
        row.maximum_tensile_force_md_ = tensileForceValueMD;
        row.maximum_tensile_force_cd_ = tensileForceValueCD;
      });

      this.sampleNumber = item.SampleNumber
      this.headerNew = 'SAMPLE NUMBER';

      console.log(this.labDataTable);
      console.log(labValues);
    },


    // Function for clicking button "New"
    handleNewButtonClick(result) {
      this.isNewButtonClicked = true;
      this.isOpenButtonClicked = false;

      // Set the default values for labDataTable
      this.labDataTable = [
        { row: '1', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '2', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '3', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '4', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
        { row: '5', maximum_tensile_force_md_: '', maximum_tensile_force_cd_: '', maximum_stretch_md_: '', maximum_stretch_cd_: '', tensileMDDisabled: false, stretchMDDisabled: false, tensileCDDisabled: false, stretchCDDisabled: false },
      ];

      var commentEntry = this.headerData.find(item => item.Parameter === 'Comment');
      commentEntry.Value = '';
      
      const currentDate = new Date();
      const formattedDate = currentDate.toLocaleString(); // You can customize the date format as needed

      // Find the "Probe Date/Time" item in the data array and update its value
      const probeDateTimeItem = this.headerData.find(item => item.Parameter === 'Sample Date/Time');
      if (probeDateTimeItem) {
        probeDateTimeItem.Value = formattedDate;
      }

      // Increment the sample number
      this.sampleNumber = result
      this.sampleNumber++
      console.log(this.sampleNumber)

      this.headerNew = 'SAMPLE NUMBER';
    },

    handleSaveButtonClick() {
      this.isNewButtonClicked = false;
      this.isOpenButtonClicked = false;
      console.log('fdfdsfsd')
    },

    disableInput(type, index) {
      console.log('#########################################')
      console.log(type)
      console.log(index)
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

.modal-content {
  border: none;
}

.custom-input {
  border: 2px solid black; /* Schwarzer Rand */
  border-radius: 8px; /* Abgerundete Ecken mit 8px Radius */
  padding: 4px 8px; /* Adjust the top and bottom padding */
}
  
.custom-input2 {
  border: 2px solid black;
  border-radius: 8px 0 0 8px; /* Obere linke Ecke abgerundet, obere rechte Ecke eckig */
  padding: 3px 8px; /* Adjust the top and bottom padding */
}

.custom-input3 {
  border: 2px solid black;
  border-radius: 8px; /* Obere linke Ecke abgerundet, obere rechte Ecke eckig */
  padding: 3px 8px; /* Adjust the top and bottom padding */
}

.buttons-container {
  display: flex;
  justify-content: center;
  margin-top: 10px; /* Einstellbarer Abstand zwischen Tabellen und Buttons */
  margin-left: 30px;
}

.btn {
  /* Stile für die Buttons */
  border: 1px solid #4a5568; /* Ändere die Farbe nach Bedarf */
  background-color: #2d3748; /* Ändere die Farbe nach Bedarf */

  padding: 0.5rem 1rem; /* Ändere die Größe nach Bedarf */
  border-radius: 0.25rem; /* Ändere die Rundung nach Bedarf */
  cursor: pointer;
}

.btn:hover {
  background-color: #1a202c; /* Ändere die Farbe nach Bedarf */
}

input {
  text-align: center;
}

.center {
  text-align: center;
  align-items: center;
}

.sample-number-heading {
  /* Styles for the sample number heading */
  font-size: 20px; /* Adjust the size as needed */
  font-weight: bold; /* Adjust the weight as needed */
}

.flex {
  display: flex;
}

.equal-height-table {
  flex-grow: 1;
  min-width: 0;
}

.table-container {
  margin: 0 10px; /* Anpassen des Abstands nach Bedarf */
}

@media print {

  #test {
    width: max-content; /* Set the width of the table container to 100% */
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
}

</style>
