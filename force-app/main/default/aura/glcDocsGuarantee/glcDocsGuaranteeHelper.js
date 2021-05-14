({
    defineEmailCheckbox : function (component){
        const opportunity = this.getParamValue(component, 'opportunity');
        if(opportunity.GOT_Signature_Email__c){
            component.set('v.isGOTSignatureEmail', true);
        }
    },
    cleanDependentField : function (component){
        const opportunity = this.getParamValue(component, 'opportunity');
        if(component.get('v.isGOTSignatureEmail') === false){
            opportunity.GOT_Signature_Email__c = null;
            this.setParamValue(component, 'opportunity', opportunity)
        }
    }
});