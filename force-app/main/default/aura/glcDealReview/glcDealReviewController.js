({
    doInit : function (component, event, helper) {
        //Check if opportunity already created
        let opportunityId = helper.getParamValue(component, 'opportunityId');
        if(opportunityId != undefined){
            helper.saveOpportunity(component);
        }
        
       
    },

    goToConsent: function(component,  event, helper) {
        helper.setParamValue(component, 'index', 0);
        helper.setParamValue(component, 'showProgressBar', 'false');
        helper.setParamValue(component, 'stage', 'consent');
        helper.changeStage(component, 0);
    },

    goToApplicantInfo: function(component,  event, helper) {
        if (helper.getParamValue(component, 'prevStage') == 'applicantInfo') {
            helper.setParamValue(component, 'index', helper.getParamValue(component, 'prevIndex'));
        } else {
            helper.setParamValue(component, 'index', 8);
            // helper.setParamValue(component, 'stageName', 'selectType');
        }
        helper.setParamValue(component, 'stage', 'applicantInfo');
        helper.changeStage(component, 0);
    },

    goToAssets: function(component,  event, helper) {
        if (helper.getParamValue(component, 'prevStage') == 'assetInfo') {
            helper.setParamValue(component, 'index', helper.getParamValue(component, 'prevIndex'));
        } else {
            helper.setParamValue(component, 'index', 2);
            helper.setParamValue(component, 'stageName', 'assetInfo');
        }
        helper.setParamValue(component, 'stage', 'assetInfo');
        helper.changeStage(component, 0);
    },

    goToDealStructure: function(component,  event, helper) {
        if (helper.getParamValue(component, 'prevStage') == 'dealStructure') {
            helper.setParamValue(component, 'index', helper.getParamValue(component, 'prevIndex'));
        } else {
            helper.setParamValue(component, 'index', 0);
        }
        helper.changeStage(component, 0);
    },

    requestApproval: function (component,  event, helper) {
        helper.sendToAspire(component);
        helper.updateOpportunityStatusToSubmitedTOCredit(component);
        
    },

    requestClosedLost: function (component,  event, helper) {
        helper.updateOpportunityStatusToClosedLost(component);
    },

    saveSyndicationValues: function (component,  event, helper) {
        helper.updateSyndicationOpptyStatus(component);
        component.set('v.showSyndication', false);
    },

    show_close_Comments: function (component, event, helper) {
        if (component.get('v.showComments')) {
            component.set('v.showComments', false);
        } else {
            component.set('v.showComments', true);
        }
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
    },

    show_Syndication: function (component, event, helper) {
        
        
        if (component.get('v.showSyndication')) {
            component.set('v.showSyndication', false);
            console.log('clicked if');
        } else {
            
            /*if (helper.getParamValue(component,'lenders') == null) {
                helper.fetchPicklistValues(component, 'Opportunity', 'Lender_s_Name__c','lenders');
                helper.fetchPicklistValues(component, 'Opportunity', 'Submission_Result__c','results');
            }*/
            let opportunityId = helper.getParamValue(component, 'opportunityId');
            component.set('v.oppId',opportunityId);
            component.set('v.showSyndication', true);
            console.log('clicked else');
        }
    }

});