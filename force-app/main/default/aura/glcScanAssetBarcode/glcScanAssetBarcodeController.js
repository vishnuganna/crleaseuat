({
    onInit : function(component,event,helper) {
        helper.init(component);

        try {
            let vins = helper.getParamValue(component, 'vins');
            if (vins != '' && vins != null && helper.getParamValue(component, 'assetCount') > 5) {
                let vinArray = vins.split('\n');
                let vin = vinArray[0];
                helper.setParamValue(component, 'vehicleMileage', '');
                helper.setParamValue(component, 'vehicleVin', vin);
                vinArray.shift();
                vins = vinArray.join('\n');
                helper.setParamValue(component, 'vins', vins);
                helper.checkAccount(component, vin, helper);
            }
        } catch (e) {
            console.log(e.message);
        }
    },
    onScanImage:function(component,event,helper){
        helper.scanImage(component);
    },
    onScanText:function(component,event,helper){
        helper.scanText(component,event);
    },
    onNoDLAvailable:function(component,event,helper){
        component.set("v.step", "editInfo");
        // helper.setParamValue(component, 'showContinueButton', true);
    },
    onContinueScannedAcc:function(component,event,helper){
        let driversLicenseNum = component.get("v.acc").Drivers_License_Number__c;
        let accName = component.get("v.acc").Name;
        let billingStreet = component.get("v.acc").BillingStreet;
        if (!driversLicenseNum || !accName) {
            helper.showMessage(component, 'Please enter Driver\'s License Number and Account Name');
            return;
        }
        if (!billingStreet) {
            billingStreet = '';
        }

        let fields = {
            'Drivers_License_Number__c': driversLicenseNum,
            'Name': accName,
            'BillingStreet': billingStreet
        };
        helper.checkAccount(component, fields, helper);
    },
    onNextVin: function(component, event, helper) {
        try {
            let vins = helper.getParamValue(component, 'vins');
            if (vins == '') {
                return;
            }
            let vinArray = vins.split('\n');
            let vin = vinArray[0];
            helper.setParamValue(component, 'vehicleMileage', '');
            helper.setParamValue(component, 'vehicleVin', vin);
            vinArray.shift();
            vins = vinArray.join('\n');
            helper.setParamValue(component, 'vins', vins);
            helper.checkAccount(component, vin, helper);
        } catch (e) {console.log(e.message)};
    },
    onSubmitForm: function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        helper.setParamValue(component,'vehicleVin', fields.VIN__c);
        helper.checkAccount(component, fields.VIN__c, helper);
    },
    onContinue: function(component, event, helper){
        // helper.createAccount(component, event, helper);
        helper.changeStage(component,1);
    },
    onCancelSubmitForm: function(component, event, helper){
        event.preventDefault();

        let componentName = '';
        if (component.get('v.fromDealerFlow') == true) {
            componentName = 'c__glcDealerPortalFlow';
            helper.changeStage(component,-1);
        } else {
            componentName = 'c__glcScanDriverLicense';
        }
        let nav = component.find("navService");
        let pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": componentName
            },
            "state": {

            }
        };
        nav.navigate(pageReference, true);
    },
    onSuccessSubmitForm: function(component, event, helper){
        let assetId = event.getParam("id");
        if (component.get('v.fromDealerFlow') == true) {
            component.set('v.params.assetId',assetId);
            helper.changeStage(component,1);
        } else {
            // helper.goToRecord(component, assetId, false);
        }
    },
    goToRecord: function(component, event, helper){
        let recordId = event.target.getAttribute("data-selected-recordId");
        let replaceNavHistory = event.target.getAttribute("data-selected-replaceNavHistory") ? true : false;
        helper.goToRecord(component,recordId,replaceNavHistory);
    },
    goHome: function(component,event,helper)
    {
        const myPageRef = {
            "type": "standard__namedPage",
            "attributes": {
                "pageName":"home"
            }
        };
        let navService = component.find("navService");
        navService.navigate(myPageRef, true);
    },
    onCheckboxChange : function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
        let availableCheckboxes = component.find('rowSelectionCheckboxId');
        let resetCheckboxValue  = false;
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.checked', resetCheckboxValue);
            });
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.checked', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.checked",true);
        component.set("v.matchingAssetId", event.getSource().get("v.label"));
    },
    onUseSelected: function(component, event, helper) {
        if (component.get('v.fromDealerFlow') == true) {
            helper.setParamValue(component,'assetId',component.get("v.matchingAssetId"));
            helper.changeStage(component,1);
        } else {
            helper.goToRecord(component, component.get("v.matchingAssetId"), false);
        }
    },
    keyCheck: function(component, event, helper) {
        let charCode = '';
        if(event.charCode)
            charCode = event.charCode;
        else if(event.keyCode)
            charCode = event.keyCode;
        else if(event.which)
            charCode = event.which;

        let searchText = component.get('v.searchText') + String.fromCharCode(charCode);
        component.set("v.searchText", searchText);

        // we are trying to find the following combination 10 13 13 at the end
        if (charCode == 13) {
            let searchLength = searchText.length;
            console.log('--- test ---');

            if (searchLength > 4 && searchText.charCodeAt(searchLength - 2) == 13 && searchText.charCodeAt(searchLength - 3) == 10) {
                helper.scanText(component, searchText, helper);
            }

            console.log('--- end test ---')
        }
        console.log(searchText);
        console.log(charCode);
        console.log(String.fromCharCode(charCode));
    }

});