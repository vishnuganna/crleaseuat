({
    doInit : function (component, event, helper){
        helper.initParams(component);
    },

    onContinue : function(component, event, helper){
        helper.continue(component);
    },

    onCancel : function(component, event, helper){
        helper.cancel(component);
    },

    onSave : function(component, event, helper){
        helper.save(component);
    },

    handleSelectChecklistStage : function (component, event, helper){
        let selectedStage = event.getParam("selectedStage")
        helper.moveToStage(component, selectedStage);
    },

    handleStageCompleted : function (component, event, helper){
        helper.completeStage(component);
    }

});