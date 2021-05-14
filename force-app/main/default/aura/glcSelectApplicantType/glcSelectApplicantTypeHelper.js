({
    setSelectedDealership : function (component){
        let dealerships = this.getParamValue(component, 'dealerships');
        for(let dealer of dealerships){
            if(dealer.selected == true){
                component.set('v.selectedDealerShipName', dealer.name);
                this.setParamValue(component, 'selectedDealershipId', dealer.id);
                break;
            }
        }
    },

    prepopulateValues : function (component){
        this.setParamValue(component, 'isVVGDeal', false);
    },

    setStructureByApplicant : function (component){
        let selectedApplicant = this.getParamValue(component, 'applicantType');

        if(selectedApplicant == 'Individual'){
            this.setParamValue(component, 'legalStructure', 'Individual/Sole Proprietor');
        }else if(selectedApplicant == 'Company'){
            let legalStructures = this.getLocalParamValue(component, 'legalStructures');
            this.setParamValue(component, 'legalStructure', legalStructures[0].value);
        }
    },

    //On next steps we will need to save this value for individual type, but it should not visible for company applicant type.
    deleteStructureForIndividual : function (component){
        let structures = this.getLocalParamValue(component, 'legalStructures');
        let filteredStructures = structures.filter(struct => struct.value != 'Individual/Sole Proprietor');
        this.setLocalParamValue(component, 'legalStructures', filteredStructures);
    },
});