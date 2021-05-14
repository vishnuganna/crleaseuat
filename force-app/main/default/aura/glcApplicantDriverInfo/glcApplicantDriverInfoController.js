({
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Account', 'Haul_Type__c', 'haulTypes');
        helper.fetchPicklistValues(component, 'Opportunity', 'Industry_Code__c', 'industryCodes');
    },
});