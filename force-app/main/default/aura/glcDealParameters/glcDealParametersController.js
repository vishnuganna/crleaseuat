({
    doInit: function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Opportunity', 'TRAC_Type__c', 'tracTypes');
        helper.fetchPicklistValues(component, 'Opportunity', 'Payment_Structure__c', 'paymentStructures');
        helper.fetchPicklistValues(component, 'Opportunity', 'Fee_Type__c', 'feeTypes');
        helper.fetchPicklistValues(component, 'Opportunity', 'Promo_Code__c', 'promoCodes');
        helper.initPaymentTimingValue(component);
        try {
            helper.fetchScoreCardInfo(component);
        } catch (e) {
            console.log(e.message);
        }
    },

    onPaymentTimingChange : function (component, event, helper){
        helper.setPaymentTiming(component, event);
    }
});