({
    doInit : function(component, event, helper){
        helper.defineEmailCheckbox(component);
    },

    onChangeGOTSignature : function(component, event, helper){
        helper.cleanDependentField(component);
    }
});