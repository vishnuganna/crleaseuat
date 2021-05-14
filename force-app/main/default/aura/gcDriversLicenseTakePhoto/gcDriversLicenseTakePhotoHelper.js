({
    updateDocument : function(component,event,docTitlesByIds) {
        let action = component.get("c.updateFiles");
        let fName = component.get("v.fileName")
        let fileNamesList = component.get("v.fileNamesList");
        let fileNamesUsed = new Map();
        for (let i = 0; i < fileNamesList.length; i++) {
            fileNamesUsed.set(fileNamesList[i], 0);
        }
        let files = component.get("v.files");
        if (files.length > 0) {
            for (let i = 0; i < files.length; i++) {
                for (let [key, value] of fileNamesList) {
                    if (files[i].Title.startsWith(key)) {
                        fileNamesUsed.set(key, value + 1);
                    }
                }
            }
        }
        let amountUsed = fileNamesUsed.get(fName);
        for (let [docId, title] of Object.entries(docTitlesByIds)) {
            let nextName = fName;
            if (amountUsed > 0) {
                nextName = fName + '-' + amountUsed;
            }
            amountUsed++;
            docTitlesByIds[docId] = nextName;
        }
        action.setParams({
            "titlesByIds":docTitlesByIds,
            "recordId": this.getParamValue(component,"accountId") //component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state=='SUCCESS'){
                let result = response.getReturnValue();
                component.set("v.files",result);
            }
        });
        $A.enqueueAction(action);
    }
});