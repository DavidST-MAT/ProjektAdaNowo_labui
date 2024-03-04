<template>
  <div>
    <button
      type="button"
      @click="sendSetLabValueToOPC"
      :disabled="isSetButtonDisabled2"
      :class="{ 'disabled-button': isSetButtonDisabled2 }"
      class="hidden-print bg-white text-black custom-button"
    >
      Set
    </button>

    <!-- Error Modal -->
    <div v-if="showErrorModal" class="error-modal">
      <div class="modal-content">
        <span class="close" @click="showErrorModal = false">&times;</span>
        <p>Error: {{ labValue }} is not a valid number.</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {

  emits: ['disable-input'],

  props: {
    row: String,
    labValue: String,
    isSetButtonDisabled: Boolean,
    parameterHeader: String,
  },

  data() {
    return {
      isSetButtonDisabled2: false,
      showErrorModal: false,
    };
  },

  methods: {
    async sendSetLabValueToOPC() {
      this.parameter = this.parameterHeader.concat(this.row);
      let labValue = this.labValue.replace(',', '.');
      const labValueObject = { [this.parameter]: this.labValue };
      console.log(labValueObject)

      if (labValue == '' || isNaN(labValue)) {
        console.error(`Error: ${labValue} is not a valid number.`);
        this.showErrorModal = true; 
        return;
      }

      try {
        const response = await axios.post(
          'http://localhost:8000/send_set_LabValue_to_opc',
          { data: labValueObject }
        );
        this.$emit('disable-input', this.parameter);
      } catch (error) {
        console.error('Error:', error);
      } finally {
        this.isSetButtonDisabled2 = true;
      }
    },
  },
};
</script>

<style>
.custom-button {
  border: 1px solid black; 
  border-radius: 0 8px 8px 0; 
  padding: 3px 8px; 
}

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

.disabled-button {
  opacity: 0.1; 
  cursor: not-allowed;
}
</style>
