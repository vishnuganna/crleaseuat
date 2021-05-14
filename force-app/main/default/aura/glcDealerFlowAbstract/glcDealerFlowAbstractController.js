({
    onInit: function (component, event, helper) {
    },

    onNext: function(component, event, helper) {
        helper.changeStage(component,1);
    },

    onPrev: function(component, event, helper) {
        helper.changeStage(component,-1);
    },

    reviseAsset: function (component, event, helper) {
        let ctarget = event.currentTarget;
        let index = ctarget.dataset.value;
        let asset = helper.getParamValue(component, 'assets')[index];
        helper.setParamValue(component, 'asset', asset);
        helper.setParamValue(component, 'assetIndex', index);
        helper.setParamValue(component, 'assetId', asset.Id);
        helper.fetchFieldsFromAsset(component);
        helper.changeStage(component, -4);
    },

    onSaveAndFinnish: function (component, event, helper) {
        helper.saveAndFinnish(component, true, helper.redirectToApplicationList.bind(helper));
    }
});