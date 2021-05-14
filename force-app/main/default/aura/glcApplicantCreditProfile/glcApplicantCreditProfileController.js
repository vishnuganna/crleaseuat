({
    doInit: function (component, event, helper) {
        component.set('v.showCorporateReport', helper.getParamValue(component,'Corporate_Credit_Only__c') == true ? true : false);

        if (helper.getParamValue(component,'stage') === 'applicantInfo') {
            try {
                helper.fetchLexisNexisInstantId(component);
            } catch (e) {
                console.log(e.message);
            }
        }
    /*
      var action = component.get('c.getAPIStatus');        
        let params = {"accountId": helper.getParamValue(component,"accountId")};        
        action.setParams(params);
        
       action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set('v.apimanager', response.getReturnValue());
        }
      });
      $A.enqueueAction(action);*/
    },


    takePaynetReport: function (component, event, helper) {
        if (helper.getParamValue(component, 'PaynetReport') == null) {
            helper.fetchPaynetReport(component);
        } else {
            component.set('v.showPaynetCompanies', false);
            $A.get('e.lightning:openFiles').fire({
                recordIds: [helper.getParamValue(component, 'PaynetReport')]
            });
        }
    },

    takePaynetCompanies: function (component, event, helper){
        if(helper.getParamValue(component, 'paynetCompanies') == null){
            helper.fetchPaynetCompanies(component);
        }else{
            component.set('v.showPaynetCompanies', true);
        }
    },

    takeExperianReport: function (component, event, helper) {
        if (helper.getParamValue(component, 'ExperianReport') == null) {
            helper.fetchExperianReport(component);
        } else {
            $A.get('e.lightning:openFiles').fire({
                recordIds: [helper.getParamValue(component, 'ExperianReport')]
            });
        }
    },

    close_PaynetCompanies: function (component, event, helper) {
        component.set('v.showPaynetCompanies', false);
    },

    close_ExperianReport: function (component, event, helper) {
        component.set('v.showExperianReport', false);
    },

    requestClosedLost: function (component,  event, helper) {
        helper.updateOpportunityStatusToClosedLost(component);
    },

    show_close_LossReason: function (component, event, helper) {
        if (component.get('v.showLossReason')) {
            component.set('v.showLossReason', false);
        } else {
            if (helper.getParamValue(component,'lossReasons') == null) {
                helper.fetchPicklistValues(component, 'Opportunity', 'Loss_Reason__c', 'lossReasons');
            }
            component.set('v.showLossReason', true);
        }
    }
});