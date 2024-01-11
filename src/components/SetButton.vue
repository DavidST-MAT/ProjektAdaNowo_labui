<template>
    <button type="button"  @click="sendSetLabValueToOPC" :disabled="isSetButtonDisabled2" class="hidden-print mt-4 hover:text-white border focus:ring-4 focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      Set
    </button>
</template>


<script>
import axios from 'axios'

export default {

    props: { 
        row: String,
        labValue: String,
        isSetButtonDisabled: Boolean,
        parameterHeader: String,
    },

    data() {
        return {
            isSetButtonDisabled2: false,
        };
    },

    methods: {

        async sendSetLabValueToOPC() {
            this.parameter = this.parameterHeader.concat(this.row)
            let labValue = this.labValue.replace(',', '.')
            const labValueObject = {[this.parameter]: this.labValue}
            console.log(this.labValue)
            console.log(labValueObject)
           

            if (labValue == '' || isNaN(labValue)) {
                console.error(`Error: ${labValue} is not a valid number.`);
                return; // Verlasse die Funktion, wenn labValue keine Zahl ist
            }

            try {
                //const response = await axios.post('http://localhost:8000/send_set_LabValue_to_opc', {data: labValueObject});
                //console.log(labValueObject);
                console.log('hi');
                this.$emit("disable-input", this.parameter);
            } catch (error) {
                console.error('Error:', error);
                //console.error('Response data:', error.response.data);
            } finally {
                this.isSetButtonDisabled2 = true;
            }
        },

    }

}
</script>