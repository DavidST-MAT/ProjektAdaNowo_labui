<!-- PrintButton.vue -->
<template>
    <button type="button" @click="handlePrintButtonClick" class="text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      Print
    </button>
  </template>
  
  <script>
  import html2pdf from 'html2pdf.js';
  
  export default {
    methods: {
      handlePrintButtonClick() {
        // Logic for generating and saving the PDF
  
        // Select the table element by its ID (replace 'yourTableId' with the actual ID)
        const tableElement = document.getElementById('yourTableId');
  
        // Check if the table element exists
        if (tableElement) {
          // Configure the PDF options
          const pdfOptions = {
            margin: 10,
            filename: 'table.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
          };
  
          // Generate the PDF using html2pdf
          html2pdf().from(tableElement).set(pdfOptions).outputPdf(pdf => {
            // Save the PDF file
            const blob = new Blob([pdf], { type: 'application/pdf' });
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = pdfOptions.filename;
            link.click();
          });
        } else {
          console.error('Table element not found.');
        }
      },
    },
  };
  </script>
  
  