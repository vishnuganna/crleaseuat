({
    jumpToDealStructure: function (component){
        this.prepopulateEquipmentCost(component);
        this.switchStageState(component, 'dealStructure', this.DEAL_STRUCTURE_STAGES, 0);
    },

    prepopulateEquipmentCost : function(component){
        this.setParamValue(component, 'equipmentCost', this.getParamValue(component, 'PreApprovalAmount'));
    }
});