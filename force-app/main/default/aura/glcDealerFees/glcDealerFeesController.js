({
    doInit: function (component, event, helper) {
        helper.prepopulatePayFreq(component);
        helper.fetchPicklistValues(component, 'Opportunity', 'Dealer_Fees__c', 'dealerFees');
        helper.fetchPicklistValues(component, 'Opportunity', 'Pymt_Frequency__c', 'paymentFreqs')
        helper.modifySlider(component);
    },

    onNext: function(component, event, helper) {
        helper.saveOpportunity(component, true);
    },

    show_close_fee_calculator: function (component, event, helper) {
        if (component.get('v.showCalculator')) {
            component.set('v.showCalculator', false);
            helper.calculateFinanceAmount(component);
        } else {
            component.set('v.showCalculator', true);
        }
    },

    onChangeAmount : function (component, event, helper) {
        helper.calculateFinanceAmount(component);
    },

    onChangeFrequency: function (component, event, helper){
        helper.modifySlider(component);
    }
});