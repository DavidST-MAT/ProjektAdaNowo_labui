<!-- PrintButton.vue -->
<template>
  <button
    type="button"
    @click="handlePrintButtonClick"
    class="hidden-print mt-4 hover:text-white border focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 bg-red-600 hover:bg-red-700 focus:ring-red-900"
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
