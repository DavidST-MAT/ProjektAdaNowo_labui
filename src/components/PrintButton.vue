<!-- PrintButton.vue -->
<template>
  <button
    type="button"
    @click="handlePrintButtonClick"
    class="hidden-print mt-4 hover:text-white border focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800"
  >
    Print
  </button>
</template>

<script>
export default {
  methods: {
    handlePrintButtonClick() {
      window.print();
    },
  },
};
</script>

<style scoped>
@media print {
  .hidden-print {
    display: none !important;
  }

  body::after {
    content: none !important;
  }

  header, footer {
    display: none;
  }
}
</style>
