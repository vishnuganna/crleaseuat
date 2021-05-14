import { LightningElement,track,api } from 'lwc';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import createLead from '@salesforce/apex/LeadVSBAController.createLead';
import createLeadWithDecline from '@salesforce/apex/LeadVSBAController.createLeadWithDecline';
import { NavigationMixin } from 'lightning/navigation';
import Ownership_OBJECT from '@salesforce/schema/Ownership__c';
export default class PrequalificationLWC extends NavigationMixin(LightningElement) {
    @api  ownership=[];
    
    ownershipRecord=Ownership_OBJECT
    @track leadRecord = LEAD_OBJECT;
    @track selectedStep = 'Step1';
    isStep1 = false;
    isStep2=false;
    isStep3=false;
    isStep4=false;
    isStep5=false;
    isStep6=false;
    isCustomerInfo=false;
    isCitizenship=false;
    isOwnership=false;
    value = [];
    @track industryValue = '';
    @track stateValue = '';
    @track legalStatusValue='';
    progress = 15;
    isProgressing = true;
    isFranchise = false;
    isNotFranOther=false;
    isOtherNotListed=false;
     
    connectedCallback() {
        this.isStep1 = true;
        this.isStep2=false;
        this.isStep3=false;
        this.isProgressing=true;
        this.leadRecord.Is_Business_Profitable__c=false;
        this.leadRecord.Business_For_Profit__c=false;
        this.leadRecord.Legal_Permanent_Residents__c=false;
        this.leadRecord.VSBA_Franchise__c=null;
    }
    get options() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }
   
    diff_years(establishedDate) {
        console.log('establishedDate'+establishedDate);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        var dt1 = new Date(yyyy,mm,dd);
        console.log('dt1'+dt1);
        var dt2 = new Date(establishedDate);
        var Bdd = String(dt2.getDate()).padStart(2, '0');
        var Bmm = String(dt2.getMonth() + 1).padStart(2, '0'); //January is 0!
        var Byyyy = dt2.getFullYear();
       
        var dt3= new Date(Byyyy,Bmm,Bdd);
        console.log('dt3'+dt3);
        var diff =( dt1.getTime() - dt3.getTime()) / 1000;
        diff /= (60 * 60 * 24);
        if((diff/365.25)>=3){
         return true;
        }else{
            return false;
        }
       
    }

    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
        keyIndex=keyIndex-1;
    }
    handleBusinessForProfitChange(event) {
        if(event.target.checked)
            this.leadRecord.Business_For_Profit__c = event.target.checked;
        else
            this.leadRecord.Business_For_Profit__c =false;
        
    }
    handleLegalPermanentResidentsChange(event){
        if(event.target.checked)
            this.leadRecord.Legal_Permanent_Residents__c = event.target.checked;
        else
            this.leadRecord.Legal_Permanent_Residents__c = false;
    }
    businessOwnerBankruptcyHandleChange(event){
        if(event.target.checked)
            this.leadRecord.Business_Owner_Bankruptcy__c = event.target.checked;
        else
            this.leadRecord.Business_Owner_Bankruptcy__c = false;
    }
    handleChangeDisasterLoans(event){
        if(event.target.checked)
            this.leadRecord.Is_Including_SBA_And_Disaster_loans__c = event.target.checked;
        else
            this.leadRecord.Is_Including_SBA_And_Disaster_loans__c = false;
    }
    handleChangeFirstName(event){
        if(event.target.value)
            this.leadRecord.FirstName = event.target.value;
    }
    handleChangeLastName(event){
        if(event.target.value)
            this.leadRecord.LastName = event.target.value;
    }
    handleChangePhone(event){
        if(event.target.value)
            this.leadRecord.Phone = event.target.value;
    }
    handleChangeEmail(event){
        if(event.target.value)
            this.leadRecord.Email = event.target.value;
    }
    handleChangeBusinessEstablishedDate(event){
        if(event.target.value)
            this.leadRecord.Business_Established_Date__c = event.target.value;
    }
    IsBusinessProfitableHandleChange(event){
        if(event.target.checked)
            this.leadRecord.Is_Business_Profitable__c = event.target.checked;
        else
            this.leadRecord.Is_Business_Profitable__c =false;
    }
    OperatingExpenseHandleChange(event){
        if(event.target.value)
            this.leadRecord.Average_Monthly_Operating_Expense__c = event.target.value;
       

    }
    handleChangeAverageNetIncomeExceed(event){
        if(event.target.checked)
            this.leadRecord.Average_Net_Income_Exceed__c = event.target.checked;
         else
            this.leadRecord.Average_Net_Income_Exceed__c = false;

    }
    TangibleNetWorthHandleChange(event){
        if(event.target.checked)
            this.leadRecord.Tangible_Net_Worth_Exceed__c = event.target.checked;
        else
            this.leadRecord.Tangible_Net_Worth_Exceed__c = false;
    }
    handleChangeIsCriminalCharges(event){
        if(event.target.checked)
            this.leadRecord.Is_Criminal_Charges_Presently__c = event.target.checked;
        else
            this.leadRecord.Is_Criminal_Charges_Presently__c =false;

    }
    HandleChangeCriminalOffense(event){
        if(event.target.checked)
            this.leadRecord.Any_Criminal_Offense_Last_6_Months__c = event.target.checked;
        else
        this.leadRecord.Any_Criminal_Offense_Last_6_Months__c = false;
    }
    handleChangeMinorVehicleViolation(event){
        if(event.target.checked)
            this.leadRecord.Is_Minor_Vehicle_Violation__c = event.target.checked;
        else
            this.leadRecord.Is_Minor_Vehicle_Violation__c = false;
    }
    handleChangePrimaryBusinessOwner(event){
        if(event.target.value)
            this.leadRecord.Primary_Business_Owner__c = event.target.value;
    }
    handleChangeLegalBusinessName(event){
        if(event.target.value)
            this.leadRecord.Legal_Business_Name__c = event.target.value;
    }
    handleChangePrimaryBusinessPhone(event){
        if(event.target.value)
            this.leadRecord.Primary_Business_Phone__c = event.target.value;
    }
    handleChangeBusinessTaxID(event){
        if(event.target.value)
            this.leadRecord.Business_Tax_ID__c = event.target.value;
    }
    handleChangePrimaryBusinessEmail(event){
        if(event.target.value)
            this.leadRecord.Primary_Business_Email__c = event.target.value;
    }
    handleChangeBusinessStreetAddress(event){
        if(event.target.value)
            this.leadRecord.Business_Street_Address__c = event.target.value;
    }
    handleBusinessCity(event){
        if(event.target.value)
            this.leadRecord.Business_City__c = event.target.value;
    }
    handleBusinessZip(event){
        if(event.target.value)
            this.leadRecord.Business_Zip__c = event.target.value;
    }
    handleChangeOtherNotListed(event){
        if(event.target.value)
            this.leadRecord.VSBA_Other_Industry__c = event.target.value;
    }
    handleMasterPicklistChange(event){
        if(event.detail.selectedValue=='Limited Service Franchise Restaurant'){
            this.isFranchise=true;
            this.isOtherNotListed=false;
            this.isNotFranOther=false;
            
        }else if(event.detail.selectedValue=='Other / Not Listed'){
            this.isFranchise=false;
            this.isOtherNotListed=true;
            this.isNotFranOther=false;
            this.leadRecord.VSBA_Franchise__c=null;
        }else{
            this.isFranchise=false;
            this.isOtherNotListed=false;
            this.isNotFranOther=true;
            this.leadRecord.VSBA_Franchise__c=null;
        }

        if(event.detail.selectedValue!=null)
            this.leadRecord.VSBA_Industry__c=event.detail.selectedValue;

    }
    handleMasterFranchiseChange(event){
        if(event.detail.selectedValue!=null)
            this.leadRecord.VSBA_Franchise__c=event.detail.selectedValue;
    }
    handleStateNameChange(event){
        if(event.detail.selectedValue!=null)
            this.leadRecord.States_Names__c=event.detail.selectedValue;
    }
    
    createLead() {
        var data=this.template.querySelector("c-signaturelwc").handleSignature(); 
        createLead({
            leadeDeatil: this.leadRecord,
            ownershipList:this.ownership,
            b64SignData:data
            })
            .then(result => {
                // Clear the user enter values
                
                this.leadRecord =result;
            })
            .catch(error => {
                console.log(JSON.stringify(error));
                this.error = error.message;
            });
    }
    createLeadWithDecline(){
        createLeadWithDecline({
            leadeDeatil: this.leadRecord,
            ownershipList:this.ownership,
            })
            .then(result => {
                // Clear the user enter values
                this.leadRecord =result;
            })
            .catch(error => {
                console.log(JSON.stringify(error));
                this.error = error.message;
            });
    }
    

   
    
 
    step1Next() {
      
        if(this.leadRecord.Business_For_Profit__c==false ||
            this.leadRecord.Legal_Permanent_Residents__c==false ||
            this.leadRecord.Business_Owner_Bankruptcy__c==true ||
            this.leadRecord.Is_Including_SBA_And_Disaster_loans__c==true){
            this.navigateToDeclinePage();
        }else{
        this.isStep1=false;
        this.isStep2=true;
        this.isStep3=false;
        this.isStep4=false;
        this.isStep5=false;
        this.progress=30;
        }
    }
 
    step1Prev() {
            this.isStep1=true;
            this.isStep2=false;
            this.isStep3=false;
            this.isStep4=false;
            this.isStep6=false;
            this.progress=15;
            this.isStep5=false;
    }
    step2Next() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
            console.log('date'+this.leadRecord.Business_Established_Date__c);
            let yearCount=this.diff_years(this.leadRecord.Business_Established_Date__c);
           
            if(this.leadRecord.Average_Net_Income_Exceed__c==true ||
                this.leadRecord.Tangible_Net_Worth_Exceed__c==true ||
                this.leadRecord.Is_Business_Profitable__c==false ||
                yearCount==false ||
                this.leadRecord.Average_Monthly_Operating_Expense__c  < 37500 ||
                this.leadRecord.Average_Monthly_Operating_Expense__c > 175000){
                    this.createLeadWithDecline();
                    this.navigateToDeclinePage();
                }else{
                    this.isStep1=false;
                    this.isStep2=false;
                    this.isStep3=true;
                    this.isStep4=false;
                    this.isStep6=false;
                    this.progress=45;
                    this.isStep5=false;
                }
           

        }
      
      
    }

    step2Prev() {
        this.isStep1=false;
        this.isStep2=true;
        this.isStep3=false;
        this.isStep4=false;
        this.isStep5=false;
        this.isStep6=false;
        this.progress=30;
    }
    step3Next() {
        if(this.leadRecord.Is_Criminal_Charges_Presently__c==true ||
            this.leadRecord.Any_Criminal_Offense_Last_6_Months__c == true ||
            this.leadRecord.Is_Minor_Vehicle_Violation__c ==true){
                this.createLeadWithDecline();
                this.navigateToDeclinePage();

            }else{
      
                this.isStep1=false;
                this.isStep2=false;
                this.isStep3=false;
                this.isStep4=true;
                this.isStep5=false;
                this.isStep6=false;
                this.progress=60;
            }
    }
    
    step3Prev() {
        this.isStep1=false;
        this.isStep2=false;
        this.isStep3=true;
        this.isStep4=false;
        this.isStep5=false;
        this.isStep6=false;
        this.progress=45;
    }
    step4Next() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
           if(this.leadRecord.VSBA_Franchise__c=='Other'){
                this.createLeadWithDecline();
                this.navigateToDeclinePage();
           }else{
              
            this.isStep1=false;
            this.isStep2=false;
            this.isStep3=false;
            this.isStep4=false;
            this.isStep6=false;
            this.isStep5=true;
            this.progress=75;
           }
            
        }
      
        
    }
    step4Prev() {
        this.isStep1=false;
        this.isStep2=false;
        this.isStep3=false;
        this.isStep4=true;
        this.isStep5=false;
        this.isStep6=false;
        this.progress=60;
    }
   
    step5Prev() {
        this.isStep1=false;
        this.isStep2=false;
        this.isStep3=false;
        this.isStep4=false;
        this.isStep5=true;
        this.isStep6=false;
        this.progress=75;
    }
    step7Next() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
    if (isInputsCorrect) {
        this.createLead();
        this.isStep1=false;
        this.isStep2=false;
        this.isStep3=false;
        this.isStep4=false;
        this.isStep5=false;
        this.isStep6=false;
        this.navigateToConfirmationPage();
        this.isProgressing=false;
    }
    }
    step6Prev() {
        this.isStep1=false;
        this.isStep2=false;
        this.isStep3=false;
        this.isStep4=false;
        this.isStep5=true;
        this.isStep6=false;
        this.progress=75;
    }
    navigateToDeclinePage() {
       
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "/decline"
            }
        });
    }
    navigateToConfirmationPage() {
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "/confirmation"
            }
        });
    }
    fetchValue(event){
      
        if(event.detail==true){
            this.isStep1=false;
            this.isStep2=false;
            this.isStep3=false;
            this.isStep4=true;
            this.isStep5=false;
            this.isStep6=false;
            this.progress=75;

        }else{
            this.isStep1=false;
            this.isStep2=false;
            this.isStep3=false;
            this.isStep4=false;
            this.isStep5=false;
            this.isStep6=true;
            this.progress=90;
            this.ownership = event.detail;

        }
            
    }

}