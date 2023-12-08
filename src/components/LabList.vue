<template>
    <div class="modal">
      <div class="modal-content flex flex-col items-center">
        <div class="header flex">
            <button type="button" @click="" class="mt-4 text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">New</button>
            <button type="button" @click="" class="mt-4  text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Open</button>
        </div>


        <table class="mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 text-gray-500 dark:text-gray-100 mt-100">
          <tbody>
            <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.data" :key="index">
              <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black">
                {{ item.Paramter }}
              </th>
              <td class="px-6 py-4 dark:text-black">
                <input v-model="item.Value" type="text" text-center/>
              </td>

            </tr>
          </tbody>    
        </table>

        <table class="mx-auto my-4 border-separate border-spacing-2 border border-slate-500 text-sm text-left dark:bg-gray-100 text-gray-500 dark:text-gray-100 mt-100">
        <tbody>
          <tr class="bg-white border-b dark:bg-gray-200 dark:border-gray-300" v-for="(item, index) in this.data2" :key="index">
            <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-black">
              {{ item.Paramter }}
            </th>
            <td class="px-6 py-4 dark:text-black">
              <input v-model="item.Value" type="text" text-center/>
            </td>
            <td class="px-6 py-4 dark:text-black">
              {{ item.Unit }}
            </td>
            <td class="px-6 py-4 dark:text-black">
              <button type="button" @click="handleSetButtonClick(item)" class="btn">Set</button>
            </td>
          </tr>
        </tbody>    
      </table>

        <div class="flex">
        <button type="button" @click="" class="text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Print</button>
        <button type="button" @click="" class="text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">Save</button>
      </div>
     </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      show: Boolean,
    },
  
    data() {
      return {
        currentValue: '',
        data : [
            { Paramter: 'Probe Date/Time', Value: 'Placeholder'},
            { Paramter: 'Tester', Value: 'Placeholder'},
            { Paramter: 'Product', Value: 'Placeholder'},
            { Paramter: 'Batch number', Value: 'Placeholder'}
            ],
        data2 : [
            { Paramter: 'Required Parameter A', Value: 'Placeholder', Unit: 'Unit'},
            { Paramter: 'Required Parameter B', Value: 'Placeholder', Unit: 'Unit'},
            { Paramter: 'Optional Parameter A', Value: 'Placeholder', Unit: 'Unit'},
            { Paramter: 'Optional Parameter A', Value: 'Placeholder', Unit: 'Unit'}
          ],
      }}      
      }
  </script>


<style>

  /* CSS-Styling für die Komponente */
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

</style>