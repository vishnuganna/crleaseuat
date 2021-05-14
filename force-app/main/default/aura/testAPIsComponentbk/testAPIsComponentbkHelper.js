({
	fetchExperianReport : function(component) {
        this.showSpinner(component);
        let params = {
            "account": component.get('v.account'),
            "contactPrimary": component.get('v.contact'),
            "contactSecondary": this.getParamValue(component, 'coContact'),
            "contactPrimaryId": '00304000008O9l8AAC',
            "contactSecondaryId": this.getParamValue(component, 'coContactId')
        };

        let action = component.get("c.getExperianReport");
        action.setParams(params);

        action.setCallback(this, function(response) {
            console.log(JSON.stringify(response));
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log(result);
                this.setParamValue(component, "ExperianReport", result);
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [result]
                });
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },
    
    fetchPaynetCompanies :function (component){
        this.showSpinner(component);
        let params = {
            //"accountId": this.getParamValue(component, 'accountId')
            "accountId": '0010400000BdtWdAAJ'
        };

        let action = component.get("c.getPaynetCompanies");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let companies =[];
                if(result != null){
                for(let res of result){
                    companies.push({id: res.company.paynet_id, name: res.company.name})
                }
                this.setParamValue(component, "paynetCompanies", companies)
                this.setParamValue(component, "selectedPaynetCompanyId", companies[0].id);
                component.set('v.showPaynetCompanies', true);
            }
            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    fetchPaynetReport : function(component) {
        this.showSpinner(component);
        let params = {
            "accountId": this.getParamValue(component, 'accountId'),
            "paynetId" : this.getParamValue(component, 'selectedPaynetCompanyId')
        };

        let action = component.get("c.getPaynetReport");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                this.setParamValue(component, "PaynetReport", result);
                component.set('v.showPaynetCompanies', false);
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [result]
                });

            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },
     fetchAccount: function(component){
        let params = {
            "accountId": this.getParamValue(component, 'accountId')
        };
        let action = component.get("c.listAccount");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let accountrec = response.getReturnValue();
              //  this.setParamValue(component,'account',accountrec);
            } else {
                helper.showApexError(component, response.getError());
            }
         });
        $A.enqueueAction(action);
    },
    fetchContact: function(component){
        let params = {
            "contactId": this.getParamValue(component, 'contactId')
        };
        let action = component.get("c.listContact");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let contactrec = response.getReturnValue();
              //  this.setParamValue(component,'contact',contactrec);
            } else {
                helper.showApexError(component, response.getError());
            }
         });
        $A.enqueueAction(action);
    },
  
})