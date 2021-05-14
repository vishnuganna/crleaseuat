({
    onInit : function(component,event,helper) {
        if (helper.getParamValue(component, 'coApplicant') == true && helper.getParamValue(component, 'coAccountId') == null) {
            helper.setParamValue(component, 'mail','');
            helper.setParamValue(component, 'phone','');
            helper.setParamValue(component, 'ssn','');
        }
    }
});