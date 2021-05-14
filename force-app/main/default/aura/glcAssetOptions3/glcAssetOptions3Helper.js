({
    prepopulatePageValues : function (component){
        //All asset should have same value from this page
        const assets = this.getParamValue(component, 'assets');
        const titlePage = {
            isProcessingTitle : assets[0].CrossroadsTitle__c ? assets[0].CrossroadsTitle__c : false,
            isProcessingRegistration : assets[0].CrossroadsReg__c ? assets[0].CrossroadsReg__c : false,
            isIRP : assets[0].IRP__c ? assets[0].IRP__c : false,
            vinVerification : assets[0].VIN_Verification_Number__c,
        }
        this.setParamValue(component, 'titlePage', titlePage);
    },

    resetProcessingToggles : function (component, titlePage){
        titlePage.isProcessingRegistration = false;
        titlePage.isIRP = false;
        this.setParamValue(component, 'titlePage', titlePage);
    }
});