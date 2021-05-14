({
    onInit : function (component, event, helper) {
        helper.saveAssetStateBeforeEdit(component);
        helper.setCurrentAsset(component);
    },

    onPreview : function (component, event, helper) {
        helper.decreaseIndex(component);
        helper.setCurrentAsset(component);
    },

    onNext : function (component, event, helper) {
        helper.increaseIndex(component);
        helper.setCurrentAsset(component);
    },

    onSaveOverride : function (component, event, helper) {
        const saveAction = component.get("v.save");
        $A.enqueueAction(saveAction);
    },

    onInfoSameForAllAssets : function (component, event, helper) {
        const isApplyForAll = helper.getParamValue(component, 'isGPSApplyForAllAssets');
        if(isApplyForAll){
            //Set first asset in array as default for all,
            helper.setIndex(component, 0);
        }else{
            helper.setIndex(component, component.get('v.index'));
        }
        helper.setCurrentAsset(component);
    }
});