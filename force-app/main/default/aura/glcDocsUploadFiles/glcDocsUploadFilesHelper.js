({
    cleanDependentField : function (component){
        const titlePage = this.getParamValue(component, 'titlePage');
        if(component.get('v.isVinVerification') === false){
            titlePage.vinVerification = null;
            this.setParamValue(component, 'titlePage', titlePage)
        }
    },

    setMultiloading : function (component) {
        const currentStage = this.getParamValue(component, 'stage');
        const isMultiloading = currentStage == 'assetTitle' ? true : false;
        component.set('v.isMultiloading', isMultiloading);
    }
});