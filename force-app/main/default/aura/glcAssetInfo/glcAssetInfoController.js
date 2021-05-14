({
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Asset', 'Vehicle_Type__c', 'vehicleTypes');
        helper.fetchPicklistValues(component, 'Asset', 'Make__c', 'vehicleMakes');
        helper.fetchVinVerification(component);
    },

    onChangeConfig : function (component, event, helper) {
        let configs = helper.getParamValue(component, 'configurations');
        let configurationId = helper.getParamValue(component, 'configurationSelected');

        for (let index in configs) {
            if (configs[index].configuration.configurationId == configurationId) {
                helper.setConfiguration(component, configs[index]);
                break;
            }
        }
    }
});