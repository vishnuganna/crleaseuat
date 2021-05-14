({
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Opportunity', 'First_Payment_Due_Options__c', 'firstPaymentDueOptions')
            .then((pickList) => {helper.prepopulatePicklistValueIfEmpty(component, pickList, 'First_Payment_Due_Options__c')});

        helper.fetchPicklistValues(component, 'Opportunity', 'Industry_Code__c', 'industryCodes')
            .then((pickList) => {helper.prepopulatePicklistValueIfEmpty(component, pickList, 'Industry_Code__c')});
    },

    onPaymentDatePicklistChange : function (component, event, helper){
        helper.cleanDependentField(component);
    }
});