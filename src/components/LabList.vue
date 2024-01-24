<template>
  <div class="modal">
    <div class="modal-content flex flex-col items-center">

      <h2 class="sample-number-heading">{{ headerNew }} {{ sampleNumber }}</h2>
      <div class="header flex">
        <NewButton @newButtonClick="handleNewButtonClick" />
        <OpenButton @openButtonClick="handleOpenButtonClick" @row-clicked="handleRowClick"/>
      </div>

      <template v-if="isNewButtonClicked || isOpenButtonClicked">
      
        <table  class="mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 text-gray-500 dark:text-gray-100 mt-100">
          <tbody id="labUIdata">
            <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.headerData" :key="index">
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
                  <textarea v-model.lazy="item.Value" rows="4" cols="22"></textarea>
                </template>
                <template v-else>
                  <div class="text-center align-middle">{{ item.Value }}</div>
                </template>
              </td>

            </tr>
          </tbody>    
        </table>

        <div class="table-container equal-height-table mt-4">
  <table class="test mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 dark:text-gray-100 mt-100 equal-height-table">

    <!-- Table head -->
    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-red-300 dark:text-gray-800">
      <tr class="text-center align-middle">
        <!-- Headings for each column -->
        <th v-for="header in headers" :key="header" scope="col" class="px-6 py-3">
          {{ header }}
        </th>
      </tr>
    </thead>

    <tbody>
      <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.labDataTable" :key="index">
        <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black w-20 text-center align-middle">
          {{ item.row }}
        </th>
        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden w-full">
            <input v-model="item.maximum_tensile_force_" :disabled="item.tensileDisabled" type="text" />
            <SetButton :row="item.row" :labValue="item.maximum_tensile_force_" :parameterHeader="tensileHeader" @disable-input="disableInput('tensile', index)" />
          </div>
        </td>
        <td class="px-6 py-4 dark:text-black">
          <div class="flex rounded-md overflow-hidden">
            <input v-model="item.maximum_stretch_" :disabled="item.stretchDisabled" type="text" class="w-full rounded-md rounded-r-none" />
            <SetButton :row="item.row" :labValue="item.maximum_stretch_" :parameterHeader="stretchHeader" @disable-input="disableInput('stretch', index)" />
          </div>
        </td>
      </tr>
    </tbody>
  </table>
</div>

        <div class="buttons-container flex justify-end mt-4">
          <!-- <button type="button" @click="" class="hidden-print text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Save</button> -->
          <SaveButton :headerData="headerData" :sampleNumber="sampleNumber" :labDataTable="labDataTable" @button-clicked="handleSaveButtonClick"/>
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
        'Maximum Tensile Force [N]',
        'Maximum Stretch [%]'
        ],
      tensileHeader: 'maximum_tensile_force_',
      stretchHeader: 'maximum_stretch_',
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
        { row: '1', maximum_tensile_force_: '', maximum_stretch_: '', tensileDisabled: false, stretchDisabled: false },
        { row: '2', maximum_tensile_force_: '', maximum_stretch_: '', tensileDisabled: false, stretchDisabled: false },
        { row: '3', maximum_tensile_force_: '', maximum_stretch_: '', tensileDisabled: false, stretchDisabled: false },
        { row: '4', maximum_tensile_force_: '', maximum_stretch_: '', tensileDisabled: false, stretchDisabled: false },
        { row: '5', maximum_tensile_force_: '', maximum_stretch_: '', tensileDisabled: false, stretchDisabled: false },
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

    handleRowClick(item) {
      this.isOpenButtonClicked = true;
      this.isNewButtonClicked = false;
      // Verarbeite die übermittelten Daten, wenn eine Reihe geklickt wird
      console.log('Row clicked:', item);
      // Füge hier den Code hinzu, um die Daten in headerData zu aktualisieren oder zu verwenden.
      for (let i = 0; i < this.headerData.length; i++) {
        if (this.headerData[i].Parameter === 'Sample Date/Time') {
          this.headerData[i].Value = item.SampeDate; // oder einen anderen Wert von "item" verwenden
          console.log(item.SampeDate)
        } else if (this.headerData[i].Parameter === 'Tester') {
          this.headerData[i].Value = item.Tester;
        } // Füge weitere Bedingungen hinzu, um die Werte für andere Parameter zu aktualisieren
          else if (this.headerData[i].Parameter === 'Test') {
          this.headerData[i].Value = item.Test;
        } // Füge weitere Bedingungen hinzu, um die Werte für andere Parameter zu aktualisieren
          else if (this.headerData[i].Parameter === 'Test standard') {
          this.headerData[i].Value = item.TestStandard;
        } // Füge weitere Bedingungen hinzu, um die Werte für andere Parameter zu aktualisieren
          else if (this.headerData[i].Parameter === 'Article') {
            this.headerData[i].Value = item.Article;
          } // 
          else if (this.headerData[i].Parameter === 'Article number') {
            this.headerData[i].Value = item.ArticleNumber;
          } // 
          else if (this.headerData[i].Parameter === 'Order number') {
            this.headerData[i].Value = item.OrderNumber;
          } // 
          else if (this.headerData[i].Parameter === 'Batch number') {
            this.headerData[i].Value = item.BatchNumber;
          } // 
      }
    },


    // Function for clicking button "New"
    handleNewButtonClick(result) {
      this.isNewButtonClicked = true;
      this.isOpenButtonClicked = false;
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

      this.headerNew = 'sample number';
    },

    handleSaveButtonClick() {
      
      this.isNewButtonClicked = false;
      this.isOpenButtonClicked = false;

    },

    disableInput(type, index) {
      //console.log(parameter)
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

.sample-number-heading {
  /* Styles for the sample number heading */
  font-size: 24px; /* Adjust the size as needed */
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
