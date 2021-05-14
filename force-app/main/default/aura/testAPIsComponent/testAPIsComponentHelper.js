({
	fetchExperianReport : function(component) {
        component.set('v.response','');
        
        let params = {
            "account": component.get('v.account'),
            "contactPrimary": component.get('v.contact'),
            "contactSecondary": this.getParamValue(component, 'coContact'),
            "contactPrimaryId": '00304000008O9l8AAC',
            "contactSecondaryId": this.getParamValue(component, 'coContactId')
        };

        let action = component.get("c.getExperianData");
        action.setParams(params);

        action.setCallback(this, function(response) {
           
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set('v.response',result);
            } else {
                
                component.set('v.response', response.getError());
               
            }
           
        });

        $A.enqueueAction(action);
    },
    lexisNexisHelper:function(component){

        component.set('v.response','');
        let params = {
            "accountDetail": component.get('v.account'),
            "contactPrimary": component.get('v.contact')
          
        };
        let action = component.get("c.getLexisNexisBusinessInstantData");
        action.setParams(params);
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set('v.response',result);
            } else {
                component.set('v.response', JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);


    },
    lexisNexisIndividualHelper:function(component){

        component.set('v.response','');
        let params = {
           
            "contactPrimary": component.get('v.contact')
          
        };
        let action = component.get("c.getLexisNexisIndividualData");
        action.setParams(params);
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set('v.response',result);
            } else {
                component.set('v.response', JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);


    },
    
    takePaynetCompaniesHelper:function(component){
        component.set('v.response','');
       
        let params = {
            "account": component.get('v.account')
           
        };
        let action = component.get("c.getPaynetCompaniesData");
        action.setParams(params);

        action.setCallback(this, function(response) {
            console.log(JSON.stringify(response));
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set('v.response',JSON.stringify(result));
               
            } else {
                component.set('v.response',JSON.stringify( response.getError()));
               
                
            }
            
        });

        $A.enqueueAction(action);


    },
    getParamValue : function (component, parameter) {
        let params = component.get('v.params');
        return params[parameter];
    }

})