({
    onInit : function(component,event,helper) {
        helper.init(component);
    },
    //Do not delete, (fix bug in Safari after scanning)
    // it refresh page for fill fields
    refreshAfterScanning : function(component,event,helper) {
        $A.get('e.force:refreshView').fire();
    },
    onScanImage:function(component,event,helper){
        helper.scanImage(component);
    },
    onScanText:function(component,event,helper){
        helper.scanText(component,event);
    },
    onNoDLAvailable:function(component,event,helper){
        component.set("v.step", "editInfo");
    },
    onContinueScannedAcc:function(component,event,helper){
        let driversLicenseNum = component.get("v.contact").Driver_s_License__c;
        let accName = component.get("v.contact").FirstName + ' ' + component.get("v.contact").LastName;
        let billingStreet = component.get("v.contact").MailingStreet;
        if (!accName) {
            helper.showMessage(component, 'Please enter Account Name');
            return;
        }
        // if (!driversLicenseNum) {
        //     helper.showMessage(component, 'Please enter Driver\'s License Number');
        //     return;
        // }
        if (!billingStreet) {
            billingStreet = '';
        }

        let fields = {
            'Drivers_License_Number__c': driversLicenseNum,
            'Name': accName,
            'BillingStreet': billingStreet
        };

        if (helper.getParamValue(component, 'coApplicant') == true ||
            helper.getParamValue(component, 'Is_Additional_Business_Contact__c') == true) {
            helper.setParamValue(component, "coContact", component.get("v.contact"));
        } else {
            helper.setParamValue(component, "contact", component.get("v.contact"));
        }

        helper.checkAccount(component, fields, helper);
    },
    onSubmitForm: function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        let contact = {
            'sobjectType' : 'Contact'
        };
        Object.getOwnPropertyNames(fields).forEach(
           function (val, idx, array) {
               if (fields[val] != null){
                   contact[val] = fields[val];
               }
        });

        component.set("v.contact", contact);
        helper.setParamValue(component,helper.getParamValue(component, 'coApplicant') == true ? "coContact" : "contact",contact);
        // helper.transferFieldsFromContactToAccount(component);

        let driversLicenseNum = component.get("v.contact").Driver_s_License__c;
        let accName = component.get("v.contact").FirstName + ' ' + component.get("v.contact").LastName;
        if (!accName) {
            helper.showMessage(component, 'Please enter Name');
            return;
        }

        let billingStreet = component.get("v.contact").MailingStreet;
        let accountFields = {
            'Drivers_License_Number__c': driversLicenseNum,
            'Name': accName,
            'BillingStreet': billingStreet
        };
        helper.checkAccount(component, accountFields, helper);
    },
    onContinue: function(component, event, helper){
        // helper.createAccount(component, event, helper);
        helper.saveAccount(component, true, true, true);
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
        let accountId = event.getParam("id");
        if (component.get('v.fromDealerFlow') == true) {
            helper.setParamValue(component,'accountId',accountId);
            helper.changeStage(component,1);
        } else {
            helper.goToRecord(component, accountId, false);
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
        component.set("v.matchingAccountId", event.getSource().get("v.label"));
    },
    onUseSelected: function(component, event, helper) {
        if (component.get('v.fromDealerFlow') == true) {
            if (helper.getParamValue(component, 'coApplicant') == true) {
                helper.setParamValue(component, 'coAccountId', component.get("v.matchingAccountId"));
            } else {
                helper.setParamValue(component, 'accountId', component.get("v.matchingAccountId"));
            }
            helper.saveAccount(component, true, true, true);
        } else {
            helper.goToRecord(component, component.get("v.matchingAccountId"), false);
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
    },
    handleOnLoad : function (component, event, helper){
        let contactRole = helper.getContactRole(component);
        if(contactRole !== null){
            component.find("contactRole").set("v.value", contactRole);
        }
    }

});