({
    prepopulatePicklistValueIfEmpty : function (component, picklist, field){
        const opportunity = this.getParamValue(component, 'opportunity');
        if(!opportunity[field]){
            opportunity[field] = picklist[0].key;
        }
        this.refreshOpportunityState(component, opportunity);
    },

    cleanDependentField : function(component){
        const opportunity = this.getParamValue(component, 'opportunity');
        if(opportunity.First_Payment_Due_Options__c !== 'Other (Requires Approval)'){
            opportunity.First_Payment_Due__c = null;
            this.refreshOpportunityState(component, opportunity);
        }
    },

    refreshOpportunityState : function (component, opportunity){
        this.setParamValue(component, 'opportunity', opportunity);
    }
});