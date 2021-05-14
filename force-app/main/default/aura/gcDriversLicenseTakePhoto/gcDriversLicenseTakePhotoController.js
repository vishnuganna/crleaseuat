({
    doInit:function(component,event,helper){
        let recordId = helper.getParamValue(component,'stage') === 'assetInfo' ? helper.getParamValue(component,"assetId") : helper.getParamValue(component,"accountId");
        component.set('v.recordId', recordId);

        if (helper.getParamValue(component,'stage') === 'assetInfo') {
            try {
                helper.fetchTruckValuation(component);
            } catch (e) {
                console.log(e.message);
            }
        }

         let action = component.get("c.getFiles");
         action.setParams({
           "recordId":recordId,
           "title":component.get("v.fileName")
         });
         action.setCallback(this,function(response){
            let state = response.getState();
            if (state=='SUCCESS'){
                let result = response.getReturnValue();
                component.set("v.files",result);
            }
         });
         $A.enqueueAction(action);
    },
    openFile :function(component,event,helper){
        let rec_id = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [rec_id] //file id
        });
    },
    uploadFinished : function(component, event, helper) {
        try {
            let uploadedFiles = event.getParam("files");
            let docTitlesByIds = component.get("v.titlesByIds");
            for (let i = 0; i < uploadedFiles.length; i++) {
                let documentId = uploadedFiles[i].documentId;
                let fileName = uploadedFiles[i].name;
                docTitlesByIds[documentId] = fileName;
            }
            helper.setParamValue(component, 'uploadedFiles', uploadedFiles);
            helper.updateDocument(component, event, docTitlesByIds);
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "File(s) Uploaded successfully."
            });
            toastEvent.fire();

            if (helper.getParamValue(component,'stage') === 'assetInfo') {
                console.log('Inside Driverlicens Take photo' + JSON.stringify(component));
                helper.createOpportunityAssets(component);
            }
            if (helper.getParamValue(component, 'stageName') === 'documentsPhotos' && helper.getParamValue(component, 'assets').length < helper.getParamValue(component, 'assetCount')) {
                helper.addAssetHelper(component, -4);
            } else {
                helper.changeStage(component, 1);
            }
        } catch (e) {
            console.log(e.message);
        }
    },

    continueWithoutPhoto : function(component, event, helper) {
        try {
            if (helper.getParamValue(component,'stage') === 'assetInfo') {
                helper.createOpportunityAssets(component);
            }
            if (helper.getParamValue(component, 'stageName') === 'documentsPhotos' && ((helper.getParamValue(component, 'assets') == null && helper.getParamValue(component, 'assetCount') > 1) || helper.getParamValue(component, 'assets').length < helper.getParamValue(component, 'assetCount'))) {
                helper.addAssetHelper(component, -4);
            } else {
                helper.changeStage(component, 1);
            }
        } catch (e) { console.log(e.message);}
    }
})