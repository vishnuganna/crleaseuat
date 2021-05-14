({
    onProvidedCheck : function (component, event, helper){
        helper.setParamValue(component, 'isProvidedCheck', component.get('v.isProvidedCheck'));
    },

    onStepClick : function (component, event, helper){
        const selectEvt = component.getEvent('selectStageEvent');
        selectEvt.setParam('selectedStage', event.currentTarget.dataset.stage);
        selectEvt.fire();
    }
});