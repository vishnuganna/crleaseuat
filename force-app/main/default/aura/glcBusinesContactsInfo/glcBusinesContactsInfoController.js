({
    onInit: function (component, event, helper) {
     var businessphonestr = helper.getParamValue(component, "businessPhone");
            component.set("v.params.phone",businessphonestr);
    
    },
	onAddContact: function (component, event, helper) {
        helper.saveContact(component, false, false, true);
    }
});