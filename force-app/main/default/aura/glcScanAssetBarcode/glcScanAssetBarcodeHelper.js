({
    init: function(component)
    {
        if($A.get("$Browser.formFactor") === 'DESKTOP') {
            this.focusTimerStart(component);
        }

        if(component.get("v.step") == 'editScannedAccount')
            this.parseDescription(component);

        let action = component.get("c.getCommunityURL");
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.returnUrl", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    parseDescription: function(component)
    {
        let account = component.get("v.acc");
        if(account && account.Description)
        {
            component.set("v.accParsedData",account.Description.split(';'));
        }
    },
    checkAccount: function(component, vin, helper){
        this.showSpinner(component);
        let params = {
            vin: vin,
        };
        let action = component.get("c.checkIfAssetExists");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let assets = response.getReturnValue();
                if (assets && assets.length > 0) { // account exists
                    component.set('v.matchingAssets', assets);
                    component.set('v.step', 'accountExists');
                } else { // create new account
                    // helper.createAccount(component, null, helper);
                    this.changeStage(component, 1);
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
                component.set("v.acc", response.getReturnValue());
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
    showSpinner: function (component) {
        let spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        let spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
});