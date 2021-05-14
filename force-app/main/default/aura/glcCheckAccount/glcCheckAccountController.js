({
    onInit :  function (component,event,helper) {
        helper.checkAccount(component);
    },

    createNew : function (component,event,helper) {
        helper.changeStage(component,1);
    },

    useSelected : function (component,event,helper) {
        helper.setParamValue(component,'accountId',component.get("v.matchingAccountId"));
        helper.changeStage(component,1);
    },
    onCheckboxChange : function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
        let availableCheckboxes = component.find('rowSelectionCheckboxId');
        let resetCheckboxValue  = false;
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.checked', resetCheckboxValue);
            });
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.checked', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.checked",true);
        this.setParamValue(component,'matchingAccountId', event.getSource().get("v.label"));
    }
});