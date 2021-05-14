({
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Contact', 'Driver_Type__c', 'driverTypes');
        helper.fetchPicklistValues(component, 'Opportunity', 'DurationPrimaryHaulSouce__c', 'durationPrimaryHaulSources');
    },
});