({
    doInit : function (component, event, helper) {
        // helper.fetchPicklistValues(component, 'Asset', 'Fairings__c', 'vehicleFairings');
        // helper.fetchPicklistValues(component, 'Asset', 'Aluminum_Wheels__c', 'vehicleAluminumWheels');
        helper.fetchPicklistValues(component, 'Asset', 'Body_Type__c', 'Body_Types');
    },
    onBodyTypeChange : function (component, event, helper){
        helper.resetUpfitSerialIfBodyNotSelected(component);
    },
    onApuChange : function (component, event, helper){
        helper.resetApuSerialIfApuNotSelected(component);
    },
});