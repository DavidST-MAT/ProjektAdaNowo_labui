<template>
    <button type="button"  @click="sendSetLabValueToOPC" :disabled="isSetButtonDisabled2" class="hidden-print mt-4 hover:text-white border focus:ring-4 focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-900 dark:text-gray-900 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      Set
    </button>
</template>


<script>
    import axios from 'axios'

    export default {

        props: {
           
            parameter: String,
            labValue: String,
            isSetButtonDisabled: Boolean,

        },

        data() {
            return {
                isSetButtonDisabled2: false,
            };
        },

        methods: {

            async sendSetLabValueToOPC() {
                const labValueObject = {[this.parameter]: this.labValue}

                try {
                    const response = await axios.post('http://localhost:8000/send_set_LabValue_to_opc', {data: labValueObject});
                    console.log(labValueObject);
                    this.$emit("disable-input", this.parameter);
                } catch (error) {
                    console.error('Error:', error);
                    //console.error('Response data:', error.response.data);
                } finally {
                    // Update the local property to disable the button
                    this.isSetButtonDisabled2 = true;
                }
      
            },
        }


    }
</script>