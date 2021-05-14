({
    onInit : function (component, event, helper){
        helper.prepopulatePageValues(component);
    },

    onProcessingTitleChange : function (component, event, helper) {
        let titlePage = helper.getParamValue(component, 'titlePage');

        if(!titlePage.isProcessingTitle){
            helper.resetProcessingToggles(component, titlePage);
        }
    },
});