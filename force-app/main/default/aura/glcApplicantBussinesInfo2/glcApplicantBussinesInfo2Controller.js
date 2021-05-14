({
    doInit: function (component, event, helper) {
        
        helper.fetchPicklistValues(component, 'Account', 'billingstatecode', 'states');
        var statestr = component.find("applicantTypeSel").get("v.value");
        if(statestr == null || statestr =='' || statestr =="Alabama"){        
            var stateOfIncstr = helper.getParamValue(component, 'stateOfIncorporation');
            component.find("applicantTypeSel").set("v.value",stateOfIncstr);
        }
    }
});