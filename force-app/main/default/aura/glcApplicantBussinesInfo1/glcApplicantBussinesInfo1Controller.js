({
    onInit : function (component, event, helper) {
        let accountId = helper.getParamValue(component,'accountId');
        if (accountId != null) {

        }
        helper.fetchPicklistValues(component, 'Account', 'State_Of_Incorporation__c', 'statesOfIncorporation');
    }
});