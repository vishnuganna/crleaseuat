({
    initPaymentTimingValue : function (component){
        let paymentTiming = this.getParamValue(component, 'paymentTiming');
        if(paymentTiming == undefined){
            this.setParamValue(component, 'paymentTiming', 'Advance');
        }
    },

    setPaymentTiming : function(component, event){
        const paymentTiming = event.getSource().get('v.checked') ? 'Arrears' : 'Advance';
        this.setParamValue(component, 'paymentTiming', 'Arrears');
    }
});