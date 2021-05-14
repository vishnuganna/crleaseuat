({
    INDIVIDUAL_STAGES : ['selectType', 'baseInfo', 'scanDL', 'takeDlPhoto', 'questions2', 'questions1', 'driverInfo', 'questions3', 'questions4', 'creditProfile'],
    COMPANY_STAGES : ['selectType', 'baseInfo','accountLookup', 'businesInfo1', 'businesInfo2', 'scanDL', 'takeDlPhoto', 'businessContactInfo','questions1', 'driverInfo', 'questions3', 'questions4', 'creditProfile'],
    DEAL_STRUCTURE_STAGES : ['dealerFees', 'dealParameters', 'recommendedProduct', 'reviewDeal'],

    ASSET_STAGES : ['assetCount', 'assetScan', 'assetInfo', 'options1', 'options2', 'documentsPhotos', 'review'],

    SHOW_CONTINUE_BUTTON_MAP: {assetCount: false, assetScan: false, assetInfo: false, options1: false, options2: false, documentsPhotos: false, review: false},
    SHOW_PREV_NEXT_BUTTONS_MAP: {assetCount: true, assetScan: false, assetInfo: true, options1: true, options2: true, documentsPhotos: true, review: true},
    SHOW_CANCEL_SAVE_BUTTONS_MAP: {assetCount: false, assetScan: false, assetInfo: false, options1: false, options2: false, documentsPhotos: false, review: false},
    SHOW_ASSET_SAFL_BUTTON_MAP: {assetCount: true, assetScan: false, assetInfo: false, options1: true, options2: true, documentsPhotos: false, review: true},

    SHOW_BUTTONS_MAP : {selectType: true, baseInfo: true, scanDL: false, takeDlPhoto: true, driverInfo:true, questions1: true, questions2: true, questions3: true, questions4: true, employerInfo: true, accountLookup: false, businesInfo1:true, businesInfo2: true, businessContactInfo: true, creditProfile: true},
    SHOW_PREV_BUTTON_MAP : {selectType: true, baseInfo: true, scanDL: false, takeDlPhoto: true, driverInfo:true, questions1: true, questions2: true, questions3: true, questions4: true, employerInfo: true, accountLookup:true, businesInfo1:true, businesInfo2: true, businessContactInfo: true, creditProfile: true},
    SHOW_SAFL_BUTTON_MAP : {selectType: false, baseInfo: false, scanDL: false, takeDlPhoto: false, driverInfo:true, questions1: true, questions2: true, questions3: true, questions4: false, employerInfo: false, accountLookup:false, businesInfo1:true, businesInfo2: true, businessContactInfo: true, creditProfile:false},

    TOAST_TYPES : {ERROR : 'error', WARNING : 'warning', SUCCESS : 'success', INFO : 'info'},
    DEFAULT_ERROR_MESSAGE : 'Something went wrong. Please check logs or contact tech support.',

    changeStage : function (component, indexMove, save=true) {
        let index = this.getParamValue(component, 'index') + indexMove;
        let stage = this.getParamValue(component,'stage');
        console.log('AGGGG1 stage' + stage );
        console.log('AGGGG1 indexMove' + indexMove );
        console.log('AGGGG1 index' + index );

        let stages = {};
        if (stage == 'assetInfo') {
            stages = this.ASSET_STAGES;
        } else if (stage == 'dealStructure') {
            stages = this.DEAL_STRUCTURE_STAGES;
        } else {
            stages = this.getParamValue(component, 'applicantType') == 'Individual' ? this.INDIVIDUAL_STAGES : this.COMPANY_STAGES;
        }
        console.log('AGGGG1 stagess' + stages );
        let isChangedFlow = false;
        if (index == stages.length ) {
            if (stage == 'assetInfo' ) {
                stages = this.DEAL_STRUCTURE_STAGES;
                stage = 'dealStructure';
                index = 0;
                this.switchStageState(component, stage, stages, index);
            }
            if (stage == 'applicantInfo' ) {
                stages = this.ASSET_STAGES;
                stage = 'assetInfo';
                index = 0;
                isChangedFlow = true;
                this.switchStageState(component, stage, stages, index);
            }
        }

        if (stages[index] != null) {
            if (save) {
                this.saveToSessionStorage(component);
            }
            console.log('AGGGG1 index' + index );
            this.setParamValue(component, 'stageName', stages[index]);
            this.setParamValue(component, 'progressPercent', (index+1) / stages.length * 100);
            this.setParamValue(component, 'index',index);

            if(stage == 'applicantInfo') {
                if(stages[index]== 'questions2' && this.getParamValue(component, 'coApplicant')== true) {
                    this.setParamValue(component, 'coApplicant', false);
                    this.changeStage(component, 1);
                    return;
                }
                this.setParamValue(component, 'showButtons', this.SHOW_BUTTONS_MAP[stages[index]]);
                this.setParamValue(component, 'showPrevButton', this.SHOW_PREV_BUTTON_MAP[stages[index]]);
                this.setParamValue(component, 'showSAFLButton', this.SHOW_SAFL_BUTTON_MAP[stages[index]]);
            }

            if(stage == 'assetInfo') {
                this.setParamValue(component, 'showContinueButton', this.SHOW_CONTINUE_BUTTON_MAP[stages[index]]);
                this.setParamValue(component, 'showPrevNextButtons', this.SHOW_PREV_NEXT_BUTTONS_MAP[stages[index]]);
                this.setParamValue(component, 'showCancelSaveButtons', this.SHOW_CANCEL_SAVE_BUTTONS_MAP[stages[index]]);
                this.setParamValue(component, 'showSaFLButton', this.SHOW_ASSET_SAFL_BUTTON_MAP[stages[index]]);
            }
            if (isChangedFlow === true && stage === 'assetInfo') {
                // this.saveAccount(component, false, true, true);
            }
        }
    },

    switchStageState : function(component, stage, stages, index){
        this.setParamValue(component, 'stage', stage);
        this.setParamValue(component, 'stageName', stages[index]);
        this.setParamValue(component, 'index', index);
    },

    saveToSessionStorage : function (component) {
        this.saveAndFinnish(component, false);
        // sessionStorage.removeItem('paramsMap');
        // sessionStorage.setItem('paramsMap', JSON.stringify(component.get('v.params')));
    },

    getParamValue : function (component, parameter) {
        let params = component.get('v.params');
        return params[parameter];
    },

    getLocalParamValue : function (component, parameter) {
        let params = component.get('v.localParams');
        return params[parameter];
    },

    deleteParam : function (component, parameter) {
        let params = component.get('v.params');
        delete params[parameter];
        component.set('v.params',params);
    },

    setParamValue : function (component, parameter, value) {
        let params = component.get('v.params');
        params[parameter] = value;
        component.set('v.params',params);
    },

    setLocalParamValue : function (component, parameter, value) {
        let params = component.get('v.localParams');
        params[parameter] = value;
        component.set('v.localParams',params);
    },

    getUrlParameter : function(sParam) {
        let sPageURL = decodeURIComponent(window.location.hash.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },

    fetchAttributes: function(component, objectId, reloaded, isBarcodeRedirect) {
        let params = {
            "sId": objectId
        };
        let action = component.get("c.getAttributes");
        action.setParams(params);
        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let responseValue = response.getReturnValue().replaceAll('&quot;', '"');
                let responseString;
                let parsed = false;
                try {
                    responseString = JSON.parse(responseValue);
                    parsed = true;
                } catch (e) {
                    // console.log(e.message);
                }

                if (!parsed) {
                    try {
                        responseString = JSON.parse(responseValue.substring(0,responseValue.length-2));
                        parsed = true;
                    } catch (e) {
                        // console.log(e.message);
                    }
                }

                if (parsed) {
                    component.set('v.params', responseString);
                }

                if(!reloaded && !isBarcodeRedirect) {
                    if (!this.getParamValue(component, 'onReviewPage')) {
                        this.setParamValue(component, 'prevStage', this.getParamValue(component, 'stage'));
                        this.setParamValue(component, 'prevIndex', this.getParamValue(component, 'index'));
                        this.setParamValue(component, 'prevStageName', this.getParamValue(component, 'stageName'));
                    }

                    this.setParamValue(component, 'showProgressBar', 'true');
                    this.setParamValue(component, 'stage', 'dealStructure');
                    this.setParamValue(component, 'index', 3);
                }

                this.changeStage(component, 0, false);
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchPicklistValues : function (component, objectName, fieldName, parameterName) {
        let params = { "objectName": objectName, "fieldName": fieldName };

        return this.serverCall(component, 'c.getPicklistValues', params)
                .then( result => {
                    const pickList = Object.keys(result).map(key => { return {value:result[key], key:key}});
                    this.setLocalParamValue(component, parameterName, pickList);
                    return pickList;
                })
                .catch( e => this.handleServerError(component, e))
    },

    addAssetHelper: function(component, indexChange) {
        if (this.getParamValue(component, 'assets').length >= this.getParamValue(component, 'assetCount')) {
            this.setParamValue(component, 'assetCount',this.getParamValue(component, 'assets').length + 1);
        }
        this.deleteParam(component, "asset");
        this.deleteParam(component, "assetId");
        this.deleteParam(component, "assetIndex");
        this.deleteParam(component, "configurations");
        this.changeStage(component, indexChange);
    },

    checkAccount: function(component) {
        let params = {
            accName: this.getParamValue(component,'businessName'),
            zip: this.getParamValue(component,'businessZip')
        };
        let action = component.get("c.checkIfAccountExists");
        action.setParams(params);
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let accounts = response.getReturnValue();
                if (accounts && accounts.length > 0) { // account exists
                    this.setParamValue(component, 'matchingAccounts', accounts);
                } else { // create new account
                    this.changeStage(component,1);
                }
            } else {
                this.showApexError(component, response.getError());
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    // There is known issue - force:showToast event displays toast message behind action window
    // see details - https://success.salesforce.com/issues_view?id=a1p3A000000mCRqQAM
    showMessage: function (component, message, type) {
        if($A.get("$Browser.formFactor") === 'DESKTOP') {
            component.set('v.pageMessages', message);
            $A.util.removeClass(component.find('myToast'), "slds-hide");
            $A.util.addClass(component.find('myToast'), "slds-show");

            window.setTimeout(
                $A.getCallback(function () {
                    let toast = component.find('myToast');
                    $A.util.removeClass(toast, "slds-show");
                    $A.util.addClass(toast, "slds-hide");
                }), 5000
            );
        } else {
            let messageType = !type ? 'error': type;
            this.showToast(component, message, messageType);
        }
    },

    showToast : function (component, message, type){
        let toast = $A.get("e.force:showToast");
        toast.setParams({
            type: type,
            message: message
        });
        toast.fire();
    },

    handleServerError : function (component, originalMessage, userMessage=this.DEFAULT_ERROR_MESSAGE){
        console.error(originalMessage);
        this.showToast(component, userMessage, this.TOAST_TYPES.ERROR);
    },

    showApexError: function(component, errors)
    {
        if (!(errors && errors.length)) return;

        let messages = [];

        for (let i=0; i < errors.length; i++) {
            if (errors[i].message) {
                messages.push(errors[i].message);
            }

            if (errors[i].pageErrors && errors[i].pageErrors.length) {
                for (let j = 0; j < errors[i].pageErrors.length; j++) {
                    messages.push(errors[i].pageErrors[j].message);
                }
            }
        }

        if (messages.length)
            this.showMessage(component, messages.join('\n---\n'));
    },

    showSpinner: function (component) {
        component.getSuper().set('v.isShowAbstractSpinner', true);
    },
    hideSpinner: function (component) {
        component.getSuper().set('v.isShowAbstractSpinner', false);
    },

    saveAccount: function (component, changeStep, saveContact, saveOpportunity) {
        try {

            this.showSpinner(component);

            this.transferFieldsFromContactToAccount(component);

            let mapping = {
                salesRep: 'OwnerId',
                accountId: 'Id',
                mail: 'Email_Address__c',
                businessPhone: 'Phone',
                ssn: 'SSN__c',
                legalStructure: 'Legal_Structure__c',
                businessName: 'Name',
                businessZip: 'BillingPostalCode',
                dba: 'DBA__c',
                numOfPartners: 'Total_Number_of_partners__c',
                businessAddress: 'BillingStreet',
                city: 'BillingCity',
                state: 'BillingState',
                stateOfIncorporation: 'State_Of_Incorporation__c',
                haulType: 'Haul_Type__c',
                trucksNum: 'Fleet_Size__c',
                trailersNum: 'Trailers__c',
                avgMiles: 'Annual_Mileage__c',
                EIN__c: 'EIN__c',
                yearsInBusiness: 'Years_in_Business__c',
                numberOfEmployees: 'NumberOfEmployees',
                avgRevenue: 'AnnualRevenue',
                applicantType: 'Applicant_Type__c',
                HAZMAT__c: 'Do_You_Haul_HAZMAT__c',
                Majority_in_CA__c: 'Majority_in_CA__c',
                industryCode : 'Industry_Code__c'
            };

            let account = this.getParamValue(component, "account");
            delete account.attributes;
            try {
                delete account.NumberOfEmployees;
                delete account.AnnualRevenue;
            } catch (e) {}

            account['BillingCountry'] = 'United States';

            for (let key in mapping) {
                if (this.getParamValue(component, key) != null) {
                    account[mapping[key]] = this.getParamValue(component, key);
                }
            }
            //add phone if bussinessphone is null
            //adding phone back
            if(!(this.getParamValue(component,'businessPhone')) ){
                account['Phone'] = this.getParamValue(component,'phone');
            }    
            if (this.getParamValue(component, 'coApplicant') == true) {
                this.setParamValue(component, "coAccount", account);
            } else {
                this.setParamValue(component, "account", account);
            }

            let params = {
                "account": account
            };
            let action = component.get("c.saveAccount");
            action.setParams(params);

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let accountId = response.getReturnValue();
                    if (this.getParamValue(component, 'coApplicant') == true) {
                        this.setParamValue(component, 'coAccountId', accountId);
                    } else {
                        this.setParamValue(component, 'accountId', accountId);
                    }
                    if (saveContact) {
                        this.saveContact(component, changeStep, saveOpportunity, false);
                    } else if (changeStep) {
                        this.hideSpinner(component);
                        this.changeStage(component, 1);
                    }
                } else {
                    this.hideSpinner(component);
                    this.showApexError(component, response.getError());
                }
            });

            $A.enqueueAction(action);

        } catch (e) {
            console.log(e.message);
        }
    },

    saveContact: function (component, changeStep, saveOpportunity, addMoreContact) {
        this.showSpinner(component);

        let mapping = {
            salesRep: 'OwnerId',
            accountId: 'AccountId',
            mail: 'Email',
            phone: 'Phone',
            //phone: 'HomePhone',
            ssn: 'SSN__c',
            businessName: 'Name',
            businessZip: 'MailingPostalCode',
            businessAddress: 'MailingStreet',
            buildingNum: 'MailingStreet',
            city: 'MailingCity',
            // state: 'MailingState',
            driverType: 'Driver_Type__c',
            Years_IOO_Experience__c: 'Years_IOO_Experience__c',
            Years_as_Company_Driver__c: 'Years_as_Company_Driver__c',
            Years_with_CDL__c : 'Years_with_CDL__c',
            Percent_Ownership__c: 'Percent_Ownership__c',
            Is_Additional_Business_Contact__c: 'Is_Additional_Business_Contact__c',
        };

        let contact = this.getParamValue(component, this.getParamValue(component, 'coApplicant') == true ? "coContact" : "contact");
        if (contact === null || contact === undefined) {
            contact = {'sobjectType': 'Contact', 'LastName': this.getParamValue(component, this.getParamValue(component, 'coApplicant') == true ? "coContact" : "contact")['LastName']};
        }
        delete contact.attributes;
        contact['MailingCountry'] = 'United States'; // TODO check why this is here
        contact['Id'] = this.getParamValue(component, 'coApplicant') == true ||
                        this.getParamValue(component, 'Is_Additional_Business_Contact__c') == true  ?
                        this.getParamValue(component, 'coContactId') :
                        this.getParamValue(component, 'contactId');

        for (let key in mapping) {
            if (this.getParamValue(component, key) != null) {
                contact[mapping[key]] = this.getParamValue(component, key);
            }
                
        }
            //adding homePhone back
                contact['HomePhone'] = this.getParamValue(component,'phone');
                
        if (this.getParamValue(component, 'coApplicant') == true ||
                this.getParamValue(component, 'Is_Additional_Business_Contact__c') == true) {

            if (this.getParamValue(component, 'coApplicant') == true) {
                contact['coApplicant__c'] = 'true';
            }
            this.setParamValue(component, "coContact", contact);
        } else {
            this.setParamValue(component, "contact", contact);
        }
        
        let params = {
            "contact": contact,
            "accountId": this.getParamValue(component, 'accountId')
        };
        let action = component.get("c.saveContact");
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let contactId = response.getReturnValue();
                if (this.getParamValue(component, 'coApplicant') == true ||
                            this.getParamValue(component, 'Is_Additional_Business_Contact__c') == true) {
                    this.setParamValue(component, 'coContactId', contactId);
                } else {
                    this.setParamValue(component, 'contactId', contactId);
                }
                //this.deleteParam(component, 'mail');
                //this.deleteParam(component, 'phone');
                //this.deleteParam(component, 'ssn');
                this.deleteParam(component, 'Percent_Ownership__c');
                if (saveOpportunity) {
                    let helper = this;
                    setTimeout($A.getCallback(() => helper.saveOpportunity(component, changeStep)), 3000);
                } else if (changeStep) {
                    this.hideSpinner(component);
                    this.changeStage(component, 1);
                } else if (addMoreContact) {
                    this.hideSpinner(component);
                    this.setParamValue(component, 'index', 5);
                    //this.deleteParam(component, 'contact');
                    this.deleteParam(component, 'coContact');
                    this.deleteParam(component, 'step');
                    //this.deleteParam(component, 'contactId');
                    this.deleteParam(component, 'coContactId');
                    this.setParamValue(component, 'Is_Additional_Business_Contact__c', true);
                    this.changeStage(component, 0);
                }
            } else {
                this.hideSpinner(component);
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    saveOpportunity: function (component, changeStep) {
        this.showSpinner(component);
        let mapping = {
            salesRep: 'OwnerId',
            salesRep: 'SalesUserNum__c',
            opportunityId: 'Id',
            accountId: 'AccountId',
            contactId: 'Primary_Contact__c',
            coContactId: 'Referral_Contact__c',
            isFinCommercial: 'Past_Commercial_Finance__c',
            finWhom: 'Previous_Finacier__c',
            equipmentCost: 'Equipment_Cost__c',
            isPurchReplEquipment: 'Replacement_Equipment__c',
            isbankruptcy: 'Bankruptcy__c',
            isCArevenue: 'Majority_in_CA__c',
            currEmployer: 'Current_Employer__c',
            employerPhone: 'Current_Employer_Phone__c',
            yearsWithEmployer: 'Years_with_current_employer__c',
            prevEmployer: 'Previous_Employer__c',
            yearsWithPrevEmployer: 'years_with_previous_employer__c',
            continueWithCurrEmployer: 'Continue_with_Current_Employer__c',
            trucksNum: 'Trucks__c',
            trailersNum: 'Trailers__c',
            isVVGDeal: 'VVG_Deal__c',
            DurationPrimaryHaulSouce__c: 'DurationPrimaryHaulSouce__c',
            Replacement_Equipment__c: 'Replacement_Equipment__c',
            Title_IRP_base_plated_CA__c: 'Title_IRP_base_plated_CA__c',
            Sublease__c: 'Sublease__c',
            HAZMAT__c: 'HAZMAT__c',
            SalesTeamVal: 'SalesTeam__c',
            downPayment: 'Down_Payment__c',
            financeAmount: 'Amount',
            dealPaymentStructure: 'Payment_Structure__c',
            Corporate_Credit_Only__c: 'Corporate_Credit_Only__c',
            Interest_Rate_c: 'Interest_Rate__c',
            TRACTypec: 'TRAC_Type__c',
            paymentTerm : 'Term__c',
            dealSecurityDeposit: 'Security_Deposit__c',
            App_Only_Deal__c: 'App_Only_Deal__c',
            FirstPmtDueDate : 'First_Payment_Due__c',
            proposedStartDate : 'Proposed_Start_Date__c',
            paymentTiming : 'Payment_Timing__c',
            proposedStructure : 'Deal_Structure__c',
            financedFees : 'Financed_Fees__c',
            selectedPayFreq : 'Pymt_Frequency__c',
            dealTRAC : 'TRAC_Residual__c',
            dealBlendedCOF : 'Blended_Cost_of_Funds__c',
            dealerFee : 'Dealer_Fee__c',
            promoCode : 'Promo_Code__c',
            selectedDealershipId : 'Dealership__c',
            industryCode : 'Industry_Code__c'
        };

        let opportunity = this.getParamValue(component, "opportunity");
        if (opportunity === null || opportunity === undefined) {
            opportunity = {'sobjectType':'Opportunity', 'Name':'Opportunity for ' + this.getParamValue(component,'account')['Name'], 'StageName':'Application Received'};
        }
        // avoid overwriting contacts
        if (this.getParamValue(component, 'Is_Additional_Business_Contact__c') == true ||
                this.getParamValue(component, 'coApplicant') == true) {
            delete opportunity.Primary_Contact__c;
        }
        delete opportunity.attributes;

        for (let key in mapping) {
            if (this.getParamValue(component, key) != null) {
                opportunity[mapping[key]] = this.getParamValue(component, key);
            }
        }

        this.setParamValue(component, "opportunity", opportunity);

        let params = {
            "opportunity": opportunity,
            "accountId": this.getParamValue(component, 'accountId')
        };

        let action = component.get("c.saveOpportunity");
        action.setParams(params);

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                let opportunityId = response.getReturnValue();
                this.setParamValue(component,'opportunityId', opportunityId);
                if (this.getParamValue(component, 'stageName') == 'questions3' && this.getParamValue(component, 'applicantType') != 'Individual') {
                    this.updateAccountContacts(component);
                }
                if (changeStep) {
                    this.changeStage(component, 1);
                }
            } else {
                this.hideSpinner(component);
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    fetchFieldsFromAsset : function (component) {
        let mapping;
        mapping = {
            salesRep: 'OwnerId',
            assetId: 'Id',
            vehicleVin: 'VIN__c',
            vehicleType: 'Vehicle_Type__c',
            vehicleYear: 'Year__c',
            vehicleMake: 'Make__c',
            vehicleModel: 'Model__c',
            vehicleEngineSelected: 'Engine_Model__c',
            vehicleTransmissionSelected: 'Transmission_Type__c',
            sleeperSizeSelected: 'Sleeper_Size__c',
            vehicleFairingsSelected: 'Fairings__c',
            isNewTyres: 'New_Tires__c',
            apuSelected: 'APU__c',
            isNewEquipment: 'Used_or_New__c',
            vehicleMileage: 'Mileage__c',
            vehicleEngineSelected: 'Engine_Make__c',
            vehicleTransmissionSelected: 'Transmission_Make__c',
            Sleeper_Cabin__c: 'Sleeper_Cabin__c',
            sleeperSizeSelected: 'Sleeper_Size__c'
        };

        let asset = this.getParamValue(component, "asset");

        for (let key in mapping) {
            if (asset[mapping[key]] != null) {
                this.setParamValue(component, key, asset[mapping[key]]);
            }
        }
    },

    saveAsset: function (component, changeStep) {
        this.showSpinner(component);

        let mapping;
        mapping = {
            salesRep: 'OwnerId',
            assetId: 'Id',
            vehicleVin: 'VIN__c',
            vehicleType: 'Vehicle_Type__c',
            vehicleYear: 'Year__c',
            vehicleMake: 'Make__c',
            vehicleModel: 'Model__c',
            vehicleEngineSelected: 'Engine_Model__c',
            vehicleTransmissionSelected: 'Transmission_Type__c',
            sleeperSizeSelected: 'Sleeper_Size__c',
            vehicleFairingsSelected: 'Fairings__c',
            isNewTyres: 'New_Tires__c',
            apuSelected: 'APU__c',
            isNewEquipment: 'New_or_Used__c',
            vehicleMileage: 'Mileage__c',
            vehicleEngineSelected: 'Engine_Make__c',
            vehicleTransmissionSelected: 'Transmission_Make__c',
            Sleeper_Cabin__c: 'Sleeper_Cabin__c',
            sleeperSizeSelected: 'Sleeper_Size__c',
            Body_Type__c: 'Body_Type__c',
            UpfitSerialNum : 'UpfitSerialNum__c',
            APUSerialNum : 'APUSerialNum__c',
            equipmentCost : 'Price'
        };
        let asset = this.getParamValue(component, "asset");
        let assetIndex = this.getParamValue(component, "assetIndex");
        let assetName = this.getParamValue(component, 'vehicleYear') + ',' +
                        this.getParamValue(component, 'vehicleMake') + ',' +
                        this.getParamValue(component, 'vehicleModel') + ',' ;
                        
            if((this.getParamValue(component, 'vehicleVin')))
                {
                    assetName = this.getParamValue(component, 'vehicleVin').slice(-6) + ',' + assetName ;
                }
             else{
                    assetName = assetName + '';
             }   
        if (asset === null || asset === undefined) {
            asset = {
                'sobjectType': 'Asset',
                'Name': assetName
            };
            
        }
        delete asset.attributes;
        
        for (let key in mapping) {
            asset[mapping[key]] = this.getParamValue(component, key);
        }
        asset['Fairings__c'] = asset['Fairings__c'].split(' ')[0];

        let list = this.getParamValue(component, 'assets');
        if (list == null || list == undefined) {
            list = [];
        }
        if (assetIndex === null || assetIndex === undefined) {
            list.push(asset);
            this.setParamValue(component, "assetIndex", list.length - 1);
        } else {
            list[assetIndex] = asset;
        }
        this.setParamValue(component, "assets", list);

        let params = {
            "asset": asset,
            "accountId": this.getParamValue(component, 'accountId')
        };
        console.log('AGGG1 Asset saving is ' + asset);
        console.log('AGGG2 Asset saving is ' + JSON.stringify(asset));

        let action = component.get("c.saveAsset");
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let assetId = response.getReturnValue();
                this.setParamValue(component, 'assetId', assetId);
                if (changeStep) {
                    this.hideSpinner(component);
                    this.changeStage(component, 1);
                }
            } else {
                this.hideSpinner(component);
                console.log(response.getError());
                if (changeStep) {
                    this.changeStage(component, 1);
                }
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    createOpportunityAssets: function(component) {
        let params = {
            "assetId": this.getParamValue(component, 'assetId'),
            "opportunityId": this.getParamValue(component, 'opportunityId')
        };

        let action = component.get("c.saveOpportunityAsset");
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {

            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    updateOpportunityStatusToSubmitedTOCredit: function(component) {
        //debugger;
        this.showSpinner(component);
        console.log(this.getParamValue(component, 'isPreApprovalChecked'));
        let params;
         let isapp = this.getParamValue(component, 'isPreApprovalChecked');
        if(isapp === true){
            
            params = {
            "opportunityId": this.getParamValue(component, 'opportunityId'),
            "status": "Pre-approval Requested",
            "lossReason": null,
            "notes": this.getParamValue(component, 'requestFinalCreditApprovalComments')
        };
        }
        else{
         params = {
            "opportunityId": this.getParamValue(component, 'opportunityId'),
            "status": "Submitted to Credit",
            "lossReason": null,
            "notes": this.getParamValue(component, 'requestFinalCreditApprovalComments')
        };
        }
        
        let action = component.get("c.changeContractStatus");
        action.setParams(params);
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            this.hideSpinner(component);
            if (state === "SUCCESS") {
                let toastEvent = $A.get("e.force:showToast");
                //alert(state);
                toastEvent.setParams({
                    title: "Success!",
                    message: 'Status Changed',
                    type: "success"
                });
                toastEvent.fire();
                this.saveAndFinnish(component, true, this.redirectToOpportunityKanban.bind(this));
            } else {
                this.hideSpinner(component);
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        
        });
        
        
        $A.enqueueAction(action);
    },

    updateOpportunityStatusToClosedLost: function(component) {
        this.showSpinner(component);
        let params = {
            "opportunityId": this.getParamValue(component, 'opportunityId'),
            "status":"Closed Lost",
            "lossReason": this.getParamValue(component, 'lossReason'),
            "notes": null
        };

        let action = component.get("c.changeContractStatus");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            this.hideSpinner(component);
            if (state === "SUCCESS") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: 'Status Changed',
                    type: "success"
                });
                toastEvent.fire();
                this.saveAndFinnish(component, true, this.redirectToApplicationList.bind(this));
            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    updateSyndicationOpptyStatus: function(component) {
        this.showSpinner(component);
        let params = {
            "opportunityId": this.getParamValue(component, 'opportunityId'),
            "lender": this.getParamValue(component, 'lenderNames'),
            "stage": this.getParamValue(component, 'subResults'),
            "notes": this.getParamValue(component, 'syndicateComments')
        };

        let action = component.get("c.updateSyndicationStatus");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            this.hideSpinner(component);
            if (state === "SUCCESS") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: 'Syndication Updated',
                    type: "success"
                });
                toastEvent.fire();
                //this.saveAndFinnish(component, true, this.redirectToApplicationList.bind(this));
            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },
    sendSms : function(component) {
        let params = {
            "toNumber": this.getParamValue(component, 'phone')
        };

        let action = component.get("c.sendSMS");
        action.setParams(params);

        // action.setCallback(this, function(response) {
        // });

        $A.enqueueAction(action);

    },

    sendEmail : function(component) {
        let params = {
            "toEmail": this.getParamValue(component, 'mail')
        };

        let action = component.get("c.sendEmail");
        action.setParams(params);

        // action.setCallback(this, function(response) {
        // });

        $A.enqueueAction(action);

    },

    setConfiguration : function (component, config) {
        this.setParamValue(component, 'configurationId', config.configuration.configurationId);
        // this.setParamValue(component, 'vehicleType', config.configuration.classificationName);
        this.setParamValue(component, 'vehicleYear', config.configuration.modelYear);

        let makes = this.getLocalParamValue(component, 'vehicleMakes');
        let vehicleMake = '';
        for (let key in makes) {
            if (makes[key].value.toUpperCase().substring(0, 3) === config.configuration.manufacturerName.substring(0, 3)) {
                vehicleMake = makes[key].key;
                break;
            }
        }
        if (vehicleMake === '') {
            vehicleMake = config.configuration.manufacturerName;
        }
        this.setParamValue(component, 'vehicleMake', vehicleMake);

        this.setParamValue(component, 'vehicleModel', config.configuration.modelName);
        this.setParamValue(component, 'currentConfig', config);

        for (let index in config.specifications) {
            if (config.specifications[index].specName == 'sleeper') {
                this.setParamValue(component, 'sleeperSizeSelected', config.specifications[index].specValue);
            }
            if (config.specifications[index].specName == 'engineModel') {
                this.setParamValue(component, 'vehicleEngineSelected', config.specifications[index].specValue);
            }
            if (config.specifications[index].specName == 'transmission') {
                this.setParamValue(component, 'vehicleTransmissionSelected', config.specifications[index].specValue);
            }
        }
    },

    fetchVinVerification : function(component) {
        let params = {
            "vin": this.getParamValue(component, 'vehicleVin')
        };
        this.serverCall(component, 'c.getVinVerification', params)
            .then( result => {
                this.setParamValue(component, 'configurations', result);
                this.setConfiguration(component, result[0]);
            })
            .catch( e => this.handleServerError(component, e))
    },

    fetchVinOptions : function(component) {
        let currentConfig = this.getParamValue(component, 'currentConfig');
        let params = {
            "sizeClassId": currentConfig.configuration.sizeClassId,
            "year": this.getParamValue(component, 'vehicleYear')
        };

        this.serverCall(component, 'c.getVinOptions', params)
            .then( result => this.setParamValue(component, 'options', result))
            .catch( e => this.handleServerError(component, e))
    },

    fetchTruckValuation : function(component) {
        let params = {
            "configurationId": this.getParamValue(component, 'configurationId'),
            "mileage": this.getParamValue(component, 'vehicleMileage'),
            "condition": "Good"
        };

        let action = component.get("c.getTruckValuation");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var map = response.getReturnValue();
                var list = {};
                for (let key in map ) {
                    list[key] = map[key];
                    // list.push({value:map[key], key:key});
                }

                let listTV = this.getParamValue(component, 'truckValuations');
                let assetIndex = this.getParamValue(component, 'assetIndex');
                if (listTV == null || listTV == undefined) {
                    listTV = [];
                }
                if (assetIndex == null || assetIndex == undefined) {
                    listTV.push(list);
                } else {
                    listTV[assetIndex] = list;
                }
                this.setParamValue(component, "truckValuations", listTV);
            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    fetchPaynetCompanies :function (component){
        this.showSpinner(component);
        let params = {
            "accountId": this.getParamValue(component, 'accountId')
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

    fetchExperianReport : function(component) {
        this.showSpinner(component);
        let params = {
            "account": this.getParamValue(component, 'account'),
            "contactPrimary": this.getParamValue(component, 'contact'),
            "contactSecondary": this.getParamValue(component, 'coContact'),
            "contactPrimaryId": this.getParamValue(component, 'contactId'),
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

    saveAndFinnish: function(component, isFinish, callback) {
        this.showSpinner(component);
        let mapData = component.get('v.params');
        var key = "dealerships";
        delete mapData[key]; 
        let params = {
            // "flowName": isFinish ? this.getParamValue(component, 'stage') : null,
            // "stageName": isFinish ? this.getParamValue(component, 'stageName') : null,
            "flowName": this.getParamValue(component, 'stage'),
            "stageName": this.getParamValue(component, 'stageName'),
            "mapData": JSON.stringify(mapData),
            "accountId": this.getParamValue(component, 'accountId'),
            "contactId": this.getParamValue(component, 'contactId'),
            "coContactId": this.getParamValue(component, 'coContactId'),
            "opportunityId": this.getParamValue(component, 'opportunityId'),
            "applicationId": this.getParamValue(component, 'applicationId'),
            "agreeConsent": this.getParamValue(component, 'agreeTerms'),
            "isFinish": isFinish
        };

        let action = component.get("c.saveAndFinnish");
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                let application = response.getReturnValue();
                if (this.getParamValue(component, 'applicationId') == null) {
                    this.setParamValue(component, 'applicationId', application.Id);

                    let parameter = this.getUrlParameter('applicationId');
                    if (parameter == null || parameter == undefined) {
                        if (window.location.hash == '') {
                            window.location.hash = 'applicationId=' + application.Id;
                        } else {
                            window.location.hash = window.location.hash + '&applicationId=' + application.Id;
                        }
                    }
                }
                if(callback && callback instanceof Function){
                    callback(component);
                }else{
                    this.hideSpinner(component);
                }
            } else {
                this.hideSpinner(component);
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    redirectToApplicationList : function(component){
        this.navigateTo(component, this.makeStandardPageRef('Application__c', 'list'));
    },

    redirectToOpportunityKanban : function(component){
        this.navigateTo(component, this.makeStandardPageRef('Opportunity', 'list'));
    },

    makeStandardPageRef: function(sobjectName, actionName){
        return {
            type: "standard__objectPage",
            attributes: {
                objectApiName: sobjectName,
                actionName: actionName.toLowerCase()
            }
        }
    },
    makeCommunityPageRef : function(pageName){
        return {
            type: "comm__namedPage",
            attributes: {
                name: pageName
            }
        }
    },

    navigateTo : function(component, pageReference){
        let navService = component.getSuper().find("navService");
        navService.navigate(pageReference);
    },

    transferFieldsFromContactToAccount: function(component) {
        let contact = this.getParamValue(component, 'contact');
        let account = this.getParamValue(component, 'account');

        if(account != null && this.getParamValue(component, 'accountId') != null) {
            return;
        }

        if (account === null || account === undefined) {
            account = {'sobjectType':'Account'};
        }

        account['Name'] = contact['FirstName'] + ' ' + contact['LastName'];
        account['BillingStreet'] = contact['MailingStreet'];
        account['BillingCity'] = contact['MailingCity'];
        // account['BillingState'] = contact['MailingState'];
        // account['BillingStateCode'] = contact['MailingStateCode'];
        account['BillingCountryCode'] = contact['MailingCountryCode'];
        account['BillingPostalCode'] = contact['MailingPostalCode'];
        account['BillingPostalCode'] = contact['MailingPostalCode'];
        account['Drivers_License_Number__c'] = contact['Driver_s_License__c'];
        account['Driver_s_License_Expiration_Date__c'] = contact['DL_Expire_Date__c'];
        this.setParamValue(component, 'account', account);
    },

    fetchLexisNexisInstantId: function(component) {
        let applicantType = this.getParamValue(component, 'applicantType');
        let params = applicantType == 'Individual' ? {"contactId": this.getParamValue(component, 'contactId')}
                        : {"accountId": this.getParamValue(component, 'accountId')};

        let action = applicantType == 'Individual' ? component.get("c.getLexisNexisIndividualInstantId") : component.get("c.getLexisNexisBusinessInstantId");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log(JSON.stringify(result));
                this.setParamValue(component, "LexisNexisInstantId", result);
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    fetchSalesReps: function(component) {
        let action = component.get("c.getSalesReps");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                try {
                    let list = [];
                    let map = response.getReturnValue();
                    for ( var key in map ) {
                        list.push({value:map[key], key:key});
                    }
                    this.setParamValue(component,'salesReps', list);
                    this.setParamValue(component,'salesRep', list[0].key);
                } catch (e) {
                    console.log(e.message);
                }
            } else {
                this.showApexError(component, response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchDealerships: function(component) {
        let action = component.get("c.getDealerships");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                try {
                    let list = [];
                    let map = response.getReturnValue();
                    console.log("Map");
                    console.log(map);
                    for ( let key in map ) {
                        list.push({id:key, name:map[key], selected: false});
                    }
                    //add placeholder for 1 new dealership
                    list.push({id: null, name: '', selected: false});
                    this.setParamValue(component,'dealerships', list);
                } catch (e) {
                    console.log(e.message);
                }
            } else {
                this.showApexError(component, response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    aspirePush : function(component) {
        this.showSpinner(component);
        let params = {
            "accountId": this.getParamValue(component, 'accountId'),
            "contactId": this.getParamValue(component, 'contactId'),
            "opportunityId": this.getParamValue(component, 'opportunityId'),
        };

        let action = component.get("c.pushToAspire");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log(result);
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    updateAccountContacts : function(component) {
        let params = {
            "accountId": this.getParamValue(component, 'accountId')
        };

        let action = component.get("c.updateAccountContacts");
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {

            } else {
                console.log(response.getError());
                this.showApexError(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    calculateOptionsAmount: function(component) {
        let amount = 0;
        if (this.getParamValue(component, 'isNewTyres') == true) {
            amount += 2000;
        }

        let allOptions = this.getParamValue(component, 'options');

        let fairing = this.getParamValue(component, 'vehicleFairingsSelected');
        if (fairing != '') {
            for (let index in allOptions[53].options) {
                let option = allOptions[53].options[index];
                if (option.optionNameContainsFairings && option.optionName == fairing) {
                    amount += option.optionMSRP;
                    break;
                }
            }
        }

        let apu = this.getParamValue(component, 'apuSelected');
        if (apu != '') {
            for (let index in allOptions[67].options) {
                let option = allOptions[67].options[index];
                if (option.optionNameContainsAPU && option.optionName == apu) {
                    amount += option.optionMSRP;
                    break;
                }
            }
        }

        return amount;
    },

    fetchSuperTrump : function(component) {
        this.showSpinner(component);

        let params = {
            "opportunityId" : this.getParamValue(component, 'opportunityId'),
            "proposedStructure" : this.getParamValue(component, 'proposedStructure')
        };

        let action = component.get("c.getSuperTrump");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log(result);
                this.setParamValue(component, "SuperTrump", result);
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    fetchScoreCardInfo : function(component) {
        this.showSpinner(component);
        let params = {
            "opportunityId" : this.getParamValue(component, 'opportunityId'),
            "accountId" : this.getParamValue(component, 'accountId'),
            "contactId" : this.getParamValue(component, 'contactId'),
            "assets" : this.getParamValue(component, 'assets')
        };

        let action = component.get("c.getScoreCardInfo");
        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                this.setParamValue(component, "ScoreCardInfo", result.length > 0 ? result[0] : null);
            } else {
                this.showApexError(component, response.getError());
                console.log(response.getError());
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    serverCall : function(component, methodName, params){
        this.showSpinner(component);
        return new Promise($A.getCallback((resolve, reject) => {
            let action = component.get(methodName);
            action.setParams(params);
            action.setCallback(this, (res) => {
                let state = res.getState();
                if(state === 'SUCCESS') {
                    this.hideSpinner(component);
                    resolve(res.getReturnValue());
                } else if(state === 'ERROR') {
                    this.hideSpinner(component);
                    reject(res.getError())
                }
            });
            $A.enqueueAction(action);
        }));
    },

    sendToAspire : function(component) {
        let params = {
            "opportunityId" : this.getParamValue(component, 'opportunityId'),
            "accountId" : this.getParamValue(component, 'accountId'),
            "contactId" : this.getParamValue(component, 'contactId'),
            "assets" : this.getParamValue(component, 'assets')
            
        };
        this.serverCall(component, 'c.pushToAspire', params)
            .then( result => {
                //this.setParamValue(component, 'configurations', result);
                //this.setConfiguration(component, result[0]);
                console.log('SendtoAspire Result is' + JSON.stringify(result));
            })
            .catch( e => this.handleServerError(component, e))
    },

});