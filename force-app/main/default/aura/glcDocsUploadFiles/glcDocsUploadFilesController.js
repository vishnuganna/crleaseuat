({
    onInit : function(component, event, helper) {
        helper.setMultiloading(component);
    },

    onUploadFinished : function(component, event, helper) {
        const currentStage = helper.getParamValue(component, 'stage');
        if(currentStage != 'assetTitle'){
            component.getEvent('stageCompleted').fire();
        }

        const fileIds = event.getParam("files").map(file => file.documentId);
        const params = {
            "stageTitle" : component.get('v.title'),
            "documentIds": fileIds
        }

        helper.serverCall(component, "c.updateFileName", params)
            .catch( (e) => {helper.handleServerError(component, e )})
    },

    isVinVerificationChange : function (component, event, helper){
        helper.cleanDependentField(component);
    }
})