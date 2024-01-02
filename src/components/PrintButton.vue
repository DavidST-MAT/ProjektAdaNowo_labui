<!-- PrintButton.vue -->
<template>
  <button
    type="button"
    @click="handlePrintButtonClick"
    class="text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800"
  >
    Print
  </button>
</template>

<script>
import html2pdf from 'html2pdf.js';

export default {
  methods: {
    handlePrintButtonClick() {
      var element = document.getElementById('labUIdata');
      var options = {
  margin: 10,
  filename: 'custom_filename.pdf',
  image: { type: 'jpeg', quality: 0.98 },
  html2canvas: { scale: 2 },
  jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
};

html2pdf().set(options).from(element).save();
    },
  },
};
</script>

  
  
