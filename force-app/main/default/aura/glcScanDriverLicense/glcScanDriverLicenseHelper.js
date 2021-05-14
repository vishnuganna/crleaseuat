({
    init: function(component)
    {
        if($A.get("$Browser.formFactor") === 'DESKTOP') {
            this.focusTimerStart(component);
        }

        this.setValues(component);

        // if(component.get("v.step") == 'scan') {
        //     window.sessionStorage.clear();
        // }

        if (component.get("v.step") == 'editScannedAccount') {
            // this.parseDescription(component);
            this.fetchPicklistValues(component, 'Contact', 'Opportunity_Role__c', 'opportunityRoles');
            this.fetchPicklistValues(component, 'Account', 'billingstatecode', 'states');
        }

        let action = component.get("c.getCommunityURL");
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.returnUrl", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    setValues: function(component) {
        const emptyContact = {
            Opportunity_Role__c: ''
        }
        if (this.getParamValue(component, 'account') != null) {
            component.set('v.account', this.getParamValue(component, 'account'));
        }
        component.set('v.contact', emptyContact);
        if (this.getParamValue(component, 'contact') != null && this.getParamValue(component, 'coApplicant') != 'true') {
            component.set('v.contact', this.getParamValue(component, 'contact'));
        } else if (this.getParamValue(component, 'coContact') != null && this.getParamValue(component, 'coApplicant') == 'true') {
            component.set('v.contact', this.getParamValue(component, 'coContact'));
        }
        if (this.getParamValue(component, 'opportunity') != null) {
            component.set('v.opportunity', this.getParamValue(component, 'opportunity'));
        }
        if (this.getParamValue(component, 'step') != null) {
            component.set('v.step', this.getParamValue(component, 'step'));
        }
        this.prepopulateContactRole(component);
    },
    prepopulateContactRole : function (component){
        let contactRole = this.getContactRole(component);
        if(contactRole !== null ){
            component.set('v.contact.Opportunity_Role__c', contactRole);
        }
    },
    getContactRole : function(component){
        let applicantType =  component.get('v.params.applicantType');
        if(applicantType === 'Company'){
            return 'Guarantor';
        }else if(applicantType === 'Individual'){
            return 'Customer';
        }else{
            return null;
        }
    },
    parseDescription: function(component)
    {
        let account = component.get("v.contact");
        if(account && account.Description)
        {
            component.set("v.accParsedData",account.Description.split(';'));
        }     
    },
    checkAccount: function(component, fields, helper){
        this.showSpinner(component);
        if (this.getParamValue(component, 'applicantType') == 'Company') {
            this.saveAccount(component,true, true, true);
            this.hideSpinner(component);
            return;
        }
        let params = {
            driversLicenseNumber: fields.Drivers_License_Number__c,
            accName: fields.Name,
            BillingStreet: fields.BillingStreet
        };
        let action = component.get("c.checkIfAccountExists");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let accounts = response.getReturnValue();
                if (accounts && accounts.length > 0 && this.getParamValue(component, 'coApplicant') != true) { // account exists
                    component.set('v.matchingAccounts', accounts);
                    component.set('v.step', 'accountExists');
                } else { // create new account
                    // helper.createAccount(component, null, helper);
                    this.saveAccount(component,true, true, true);
                }
            } else {
                this.showApexError(component, response.getError());
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    createAccount: function(component, event, helper){
        this.showSpinner(component);

        let account = component.get("v.account");
        delete account.attributes;
        let params = {
            "account": account
        };
        let action = component.get("c.createAccount");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let accountId = response.getReturnValue();
                if (component.get('v.fromDealerFlow') == true) {
                    helper.setParamValue(component,'accountId',accountId);
                    helper.changeStage(component,1);
                } else {
                    helper.goToRecord(component, accountId, false);
                }
            } else {
                this.showApexError(component, response.getError());
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    // scanImage: function(component)
    // {
    //     let attrs = component.get('v.componentAttributes');
    //
    //     // attrs['paramsString'] = JSON.stringify(component.get('v.params'));
    //     attrs['params'] = component.get('v.params');
    //     component.set('v.componentAttributes', attrs);
    //     // component.set('v.componentAttributes','{"params":'+JSON.stringify(component.get('v.params'))+'}');
    //     component.find('cameraScanner').launchScan();
    // },

    scanImage: function(component)
    {
        // this.setReturnPageRef(component);
        this.setReturnUrl(component);
        // console.log(component.get("v.returnUrl"));
        // var mapValue = component.get('v.params');
        // var str = "";
        // for (var key in mapValue) {
        //     if (str != "") {
        //         str += "&";
        //     }
        //     str += key + "=" + encodeURIComponent(mapValue[key]);
        // }
        // component.set('v.serviceParams','{"location":"'+encodeURI('https://uat-crossroads.cs25.force.com/dealer/s?'+str)+'"}');
        // console.log(component.get("v.serviceParams"));
        component.find('cameraScanner').launchScan();
    },
    setReturnUrl: function(component){


        let userAgent = window.navigator.userAgent;
        if(component.get("v.themeDislpayed") === 'Theme4t'
            && userAgent.indexOf("Salesforce") === -1
            && /Chrome/.test(userAgent) && !(/Chromium/.test(userAgent))) {
            component.set("v.returnUrl", component.get("v.returnUrl").replace("https://", "googlechrome://"));
        }
    },
    setReturnPageRef: function(component){
        let returnPageRef = {
            "type": "comm__namedPage",
            "attributes": {
                "pageName": component.get("v.pageName")
            }
        };
        component.set("v.returnPageRef",returnPageRef);
    },

    scanText: function(component, barcode, helper){
        this.showSpinner(component);
        console.log(barcode);
        let action = component.get("c.processScan");
        action.setParams({
            "barcode": barcode
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.account", response.getReturnValue());
                component.set("v.step", "editScannedAccount");
                helper.parseDescription(component);
            } else {
                this.showApexError(component, response.getError());
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    goToRecord: function(component, recordId, replaceNavHistory){

        this.showSpinner(component);
        component.find('navService').navigate({
            "type":"standard__recordPage",
            "attributes":{
                "recordId":recordId,
                "actionName":"view"
            }
        });
    },
    focusTimerStart: function(component)
    {
        function setFocus(){
            if(component.find('laserScanner'))
                component.find('laserScanner').focus();
        }

        //run once soon after load
        setTimeout($A.getCallback(setFocus),100);

        //run periodically
        let focusTimer = setInterval($A.getCallback(setFocus),1000);
        component.set('v.focusTimer',focusTimer);
    },
    focusTimerStop: function(component)
    {
        let focusTimer = component.get('v.focusTimer');
        clearTimeout(focusTimer);
    },


});