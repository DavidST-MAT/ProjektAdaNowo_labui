<template>
    <button type="button"  @click="sendSetLabValueToOPC" class="hidden-print text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 mr-2 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800">
      Set
    </button>
</template>


<script>
    import axios from 'axios'

    export default {

        props: {
           
            parameter: String,
            labValue: String,

        },

        methods: {

            async sendSetLabValueToOPC() {
                const labValueObject = {[this.parameter]: this.labValue}

                try {
                    //const response = await axios.post('http://localhost:8000/send_set_LabValue_to_opc', {data: labValueObject});
                    console.log(labValueObject);
                    this.isRowEnabled = false;
                } catch (error) {
                    console.error('Error:', error);
                    //console.error('Response data:', error.response.data);
                }
      
            },
        }


    }
</script>