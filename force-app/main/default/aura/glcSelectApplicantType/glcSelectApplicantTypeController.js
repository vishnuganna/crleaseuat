({
    doInit : function (component, event, helper) {
        helper.fetchPicklistValues(component, 'Opportunity', 'SalesTeam__c', 'salesTeams');
        
        helper.fetchPicklistValues(component, 'Account', 'Applicant_Type__c', 'applicantTypes')
            .then(helper.fetchPicklistValues(component, 'Account', 'Legal_Structure__c', 'legalStructures'))
            .then(() => {
                helper.deleteStructureForIndividual(component);
                helper.setStructureByApplicant(component);
            });
        helper.fetchSalesReps(component);
        helper.fetchDealerships(component);
        helper.prepopulateValues(component);
        
    },

    show_close_dealerships : function (component, event, helper){
        if(component.get("v.showDealerships")){
            component.set("v.showDealerships", false);
            helper.setSelectedDealership(component);
        }else{
            component.set("v.showDealerships", true);
        }

    
    },

    close_popup : function (component, event, helper){
        component.set("v.showDealerships", false);
    },

    onCheckDealership : function (component, event, helper){
        let selectedDealershipId = event.getSource().get('v.name');
        let dealerships = helper.getParamValue(component, 'dealerships');
        dealerships.forEach(function(dealership){
            if(dealership.id == selectedDealershipId){
                dealership.selected = true;
            }else{
                dealership.selected = false;
            }
        })
        helper.setParamValue(component, 'dealerships', dealerships);
        
    },

    onApplicantChange : function (component, event, helper) {
        helper.setStructureByApplicant(component);
    }
});