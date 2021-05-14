({
   onNext: function (component, event, helper) {
       let stageName = helper.getParamValue(component, 'stageName');
       if (stageName == 'businessContactInfo') {
           helper.saveContact(component,true, false, false);
       } else if (stageName == 'questions2' && helper.getParamValue(component, 'coApplicant') == true) {
           helper.deleteParam(component, 'mail');
           helper.deleteParam(component, 'phone');
           helper.deleteParam(component, 'ssn');
           helper.deleteParam(component, 'step');
           helper.changeStage(component, -3);
       } else if (stageName == 'creditProfile') {
           helper.saveAccount(component, true, true, true);
       } else if (stageName == 'questions4' && helper.getParamValue(component, 'applicantType') != 'Individual') {
           helper.saveAccount(component, true, true, true);
       } else  {
           helper.changeStage(component, 1);
       }
    },

    onPrev: function (component, event, helper) {
        helper.changeStage(component,-1);
    }
});