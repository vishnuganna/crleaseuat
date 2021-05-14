({
    
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Opportunity', 'Lender_s_Name__c','lenders');
        helper.fetchPicklistValues(component, 'Opportunity', 'Submission_Result__c','results');
    },
})