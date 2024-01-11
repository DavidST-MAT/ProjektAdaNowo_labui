<template>
  <div class="modal">
    <div class="modal-content flex flex-col items-center">

      <h2 class="sample-number-heading">{{ headerNew }} {{ sampleNumber }}</h2>
      <div class="header flex">
        <NewButton @newButtonClick="handleNewButtonClick" />
        <button type="button" @click="handleOpenButtonClick" class="hidden-print mt-4 hover:text-white border focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Open</button>
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
                    <TesterInput @input-change="handleInputChange" />
                </template>
                <template v-else-if="item.Parameter === 'Article'">
                  <ArticleInput @input-change="handleInputChange"/>
                </template>
                <template v-else-if="item.Parameter === 'Order number'">
                  <OrderInput @input-change="handleInputChange"/>
                </template>
                <template v-else-if="item.Parameter === 'Batch number'">
                  <BatchInput @input-change="handleInputChange"/>
                </template>
                <template v-else-if="item.Parameter === 'Article number'">
                  <ArticleNumberInput @input-change="handleInputChange"/>
                </template>
                <template v-else-if="item.Parameter === 'Comment'">
                  <textarea v-model.lazy="item.Value" rows="4" cols="22"></textarea>
                </template>
                <template v-else>
                  <input v-model="item.Value" type="text" />
                </template>
              </td>

            </tr>
          </tbody>    
        </table>

        <div class="flex" id="test">

          <div class="table-container equal-height-table mt-4">
            <table class="test mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 dark:text-gray-100 mt-100 equal-height-table">
              <tbody>
                <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.labData" :key="index">
                  <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black w-20">
                    {{ item.Parameter }}
                  </th>
                  <td class="px-6 py-4 dark:text-black">
                    <input v-model="item.Value" :disabled="isInputDisabled(item)" type="text"/>
                  </td>
                  <td class="px-6 py-4 dark:text-black">
                    {{ item.Unit }}
                  </td>
                  <td class="px-6 py-4 dark:text-black">
                    <SetButton :parameter="item.Parameter" :labValue="item.Value" @disable-input="disableInput"/>
                    <!-- <button type="button" @click="handleSetButtonClick(item)" class="btn hidden-print">Set</button> -->
                  </td>
                </tr>
              </tbody>    
            </table>
          </div>

          <div class="table-container equal-height-table mt-4">
            <table class="mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 dark:text-gray-100 mt-100 equal-height-table">
              <tbody>
                <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.labData2" :key="index">
                  <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black">
                    {{ item.Parameter }}
                  </th>
                  <td class="px-6 py-4 dark:text-black">
                    <input v-model="item.Value" :disabled="isInputDisabled(item)" type="text"/>
                  </td>
                  <td class="px-6 py-4 dark:text-black">
                    {{ item.Unit }}
                  </td>
                  <td class="px-6 py-4 dark:text-black">
                    <SetButton :parameter="item.Parameter" :labValue="item.Value" @disable-input="disableInput"/>
                    <!-- <button type="button" @click="handleSetButtonClick(item)" class="btn hidden-print">Set</button> -->
                  </td>
                </tr>
              </tbody>    
            </table>
          </div>

        </div>


        <div class="table-container equal-height-table mt-4">
            <table class="test mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 dark:text-gray-100 mt-100 equal-height-table">

                     <!-- Table head -->   
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-300 dark:text-gray-800">    
              <tr>
                <!-- Headings for each column -->
                <th v-for="header in headers" :key="header" scope="col" class="px-6 py-3">
                  {{ header }}
                </th>
              </tr>
            </thead>

              <tbody>
                <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.labDataTable" :key="index">
                  <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black w-20">
                    {{ item.row }}
                  </th>
                  <td class="px-6 py-4 dark:text-black">
                    <input v-model="item.tensileValue" :disabled="isInputDisabled(item)" type="text"/>
                    <SetButton :parameter="item.Parameter" :labValue="item.Value" @disable-input="disableInput"/>
                  </td>
                  <td class="px-6 py-4 dark:text-black">
                    <input v-model="item.stretchValue" :disabled="isInputDisabled(item)" type="text"/>
                    <SetButton :parameter="item.Parameter" :labValue="item.Value" @disable-input="disableInput"/>
                  </td>
                </tr>
              </tbody>    
            </table>
          </div>

        <div class="buttons-container flex justify-end mt-4">
          <!-- <button type="button" @click="" class="hidden-print text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Save</button> -->
          <SaveButton :headerData="headerData" :sampleNumber="sampleNumber" :labData="labData" :labData2="labData2" @button-clicked="handleSaveButtonClick"/>
          <PrintButton/>
        </div>

      </template>

    </div>
  </div>
</template>
  

<script>
import NewButton from './NewButton.vue';
import PrintButton from './PrintButton.vue';
import ArticleInput from './ArticleInput.vue';
import TesterInput from './TesterInput.vue';
import BatchInput from './BatchInput.vue';
import OrderInput from './OrderInput.vue';
import ArticleNumberInput from './ArticleNumberInput.vue';
import SaveButton from './SaveButton.vue';
import SetButton from './SetButton.vue';


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
      labData: [
        { Parameter: 'maximum tensile force 1', Value: '', Unit: 'N' },
        { Parameter: 'maximum tensile force 2', Value: '', Unit: 'N' },
        { Parameter: 'maximum tensile force 3', Value: '', Unit: 'N' },
        { Parameter: 'maximum tensile force 4', Value: '', Unit: 'N' },
        { Parameter: 'maximum tensile force 5', Value: '', Unit: 'N' },
      ],
      labData2: [
        { Parameter: 'maximum stretch 1', Value: '', Unit: '%' },
        { Parameter: 'maximum stretch 2', Value: '', Unit: '%' },
        { Parameter: 'maximum stretch 3', Value: '', Unit: '%' },
        { Parameter: 'maximum stretch 4', Value: '', Unit: '%' },
        { Parameter: 'maximum stretch 5', Value: '', Unit: '%' },
      ],

      labDataTable: [
        { row: '1', tensileValue: '', stretchValue: '' },
        { row: '2', tensileValue: '', stretchValue: '' },
        { row: '3', tensileValue: '', stretchValue: '' },
        { row: '4', tensileValue: '', stretchValue: '' },
        { row: '5', tensileValue: '', stretchValue: '' },
      ]
    };
  },
  

  methods: {

    handleInputChange(paramterName, value) {
      this.headerData.find(item => item.Parameter === paramterName).Value = value;
    },

    handleOpenButtonClick() {
      this.isOpenButtonClicked = true;
    },

    // Function for clicking button "New"
    handleNewButtonClick(result) {
      this.isNewButtonClicked = true;
      const currentDate = new Date();
      const formattedDate = currentDate.toLocaleString(); // You can customize the date format as needed

      // Find the "Probe Date/Time" item in the data array and update its value
      const probeDateTimeItem = this.headerData.find(item => item.Parameter === 'Probe Date/Time');
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

    disableInput(parameter) {
      console.log(parameter)

      if (parameter.includes("stretch")) {
        const item = this.labData2.find((labItem) => labItem.Parameter === parameter);
          if (item) {
            item.isInputDisabled = true;
          }
      } else if (parameter.includes("force")) {
        const item = this.labData.find((labItem) => labItem.Parameter === parameter);
          if (item) {
            item.isInputDisabled = true;
          }
      } else {
          console.log("Set invalid");
      }


      const item = this.labData.find((labItem) => labItem.Parameter === parameter);
      if (item) {
        item.isInputDisabled = true;
      }
    },

    isInputDisabled(item) {
      return item.isInputDisabled || false;
    },
        // Add other methods as needed
  },


  components: {
    NewButton,
    PrintButton,
    TesterInput,
    ArticleInput,
    BatchInput,
    OrderInput,
    ArticleNumberInput,
    SaveButton,
    SetButton
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
