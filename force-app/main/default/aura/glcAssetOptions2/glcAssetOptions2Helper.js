({
    resetUpfitSerialIfBodyNotSelected : function (component){
        let bodyType = this.getParamValue(component, 'Body_Type__c');
        if(bodyType == null || bodyType == 'None'){
            this.resetParam(component, 'UpfitSerialNum');
        }
    },
    resetApuSerialIfApuNotSelected : function (component){
        let apu = this.getParamValue(component, 'apuSelected');
        if(apu == null || !apu.length){
            this.resetParam(component, 'APUSerialNum');
        }
    },
    resetParam : function(component, paramName){
        this.setParamValue(component, paramName, '');
    }
});