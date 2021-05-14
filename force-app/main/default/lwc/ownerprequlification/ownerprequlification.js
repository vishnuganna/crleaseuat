import { LightningElement, track,api } from 'lwc';
import Ownership_OBJECT from '@salesforce/schema/Ownership__c';
import OwnershipNumber_FIELD from '@salesforce/schema/Ownership__c.Ownership__c';
import NAME_FIELD from '@salesforce/schema/Ownership__c.Name';
import Home_Address from '@salesforce/schema/Ownership__c.Home_Address__c';
import SSN_FIELD from '@salesforce/schema/Ownership__c.SSN__c';
import DATE_OF_BIRTH_FIELD from '@salesforce/schema/Ownership__c.Date_of_Birth__c';
import ZIP_FIELD from '@salesforce/schema/Ownership__c.Zip__c';
import City_FIELD from '@salesforce/schema/Ownership__c.City__c';
import State_FIELD from '@salesforce/schema/Ownership__c.State__c';
import Citizenship_FIELD from '@salesforce/schema/Ownership__c.Citizenship_Status__c';
import COUNTRY__FIELD from '@salesforce/schema/Ownership__c.Country__c';



import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Ownerprequlification extends LightningElement {
    @track ownershipList = []; 
    @track index = 0;
    @api recordId;
    @track ownershipNumber = OwnershipNumber_FIELD;
    @track Name = NAME_FIELD;
    @track SSN = SSN_FIELD;
    @track DATEOFBIRTH=DATE_OF_BIRTH_FIELD;
    @track homeAddress=Home_Address;
    @track zip= ZIP_FIELD;
    @track City=City_FIELD;
    @track State=State_FIELD;
    @track Citizenship=Citizenship_FIELD;

    @track isStep3=false;
    isCitizenship=false;

    @api record = {
        Ownership__c : '',
        Name : '',
        Home_Address__c:'',
        SSN__c:'',
        Date_of_Birth__c:'',
        Zip__c:'',
        State__c:'',
        City__c:'',
        Citizenship_Status__c:''


    }

    ownership = {
        Name : this.name,
        Ownership__c : this.ownershipNumber,
        Home_Address__c:this.homeAddress,
        SSN__c:this.SSN,
        Date_of_Birth__c:this.DATEOFBIRTH,
        Zip__c:this.zip,
        State__c:this.State,
        City__c:this.City,

        Citizenship_Status__c:this.Citizenship,
        key : ''
    }

    connectedCallback(){ 
        this.index = 1;
        this.ownership.key = 1;
        this.ownershipList.push(JSON.parse(JSON.stringify(this.ownership)));

     }
    addRow(){

        this.index++;
        //var i = JSON.parse(JSON.stringify(this.index));
        var i = this.index;
   
        /*this.accountList.push ({
            sobjectType: 'Account',
            Name: '',
            AccountNumber : '',
            Phone: '',
            key : i
        });*/
        this.ownership.key = i;
        this.ownershipList.push(JSON.parse(JSON.stringify(this.ownership)));
       // this.accountList.push(this.record);
        //console.log(' After adding Record List ', this.accountList);
    }
    
    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if(this.ownershipList.length>1){
            this.ownershipList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        }else if(this.ownershipList.length == 1){
            this.ownershipList = [];
            this.index = 0;
            this.isLoaded = false;
        }

        //this.dispatchEvent(new CustomEvent('deleterow', {detail: this.index}));
        //console.log(' After adding Record List ', this.dispatchEvent);
    } 

    

    handleNameChange(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].Name = event.target.value;
      
    }
    
    handleAccountNumberChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].Ownership__c = event.target.value;
    }
    handleDateBirthChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].Date_of_Birth__c = event.target.value;
    }
    
    handleSSNChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].SSN__c = event.target.value;
    }
    handleHomeAddressChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].Home_Address__c = event.target.value;
    }
    handleCityChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].City__c = event.target.value;
    }
    handleStateChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        if(event.detail.selectedValue!=null){
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            var accountVar = this.ownershipList[key];
            this.ownershipList[key].State__c = event.detail.selectedValue;
        }else{
            this.ownershipList[key].State__c=null;
        }
       
    }
    handleZipChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        var accountVar = this.ownershipList[key];
        this.ownershipList[key].Zip__c = event.target.value;
    }
    handleCitizenshipStatusChange(event) {
        if(event.detail.selectedValue!='US Citizen'){
            this.isCitizenship=true;
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            var accountVar = this.ownershipList[key];
            this.ownershipList[key].Citizenship_Status__c = event.detail.selectedValue;
        }else{
            this.isCitizenship=false;
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            var accountVar = this.ownershipList[key];
            this.ownershipList[key].Citizenship_Status__c = event.detail.selectedValue;
            //this.ownershipList[key].Country__c='United States';
        }
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
      
    }
    handleCountryCitizenshipChange(event) {
        /*this.acc.AccountNumber = event.target.value;
        console.log("AccountNumber", this.acc.AccountNumber);*/
        if(event.detail.selectedValue!=null){
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            //this.ownershipList[key].Country__c = event.detail.selectedValue;
            //this.ownershipList[key].Country__c ='United States';
        }else{
            //this.ownershipList[key].Country__c=null;
        }
        console.log('ownershipList'+JSON.stringify(this.ownershipList));
       
    }
    
    step5Next(){    
        var totalOwnership = 0;   
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
          
            var i;
            for (i = 0; i < this.ownershipList.length ; i++) {
                totalOwnership = totalOwnership + parseInt(this.ownershipList[i].Ownership__c);
            } 
        if (isInputsCorrect && totalOwnership == 100)  { 
            console.log('this.ownershipList'+JSON.stringify( this.ownershipList));
            const selectedEvent = new CustomEvent("ownership", {
                detail: this.ownershipList
                });
                  // Dispatches the event.
            this.dispatchEvent(selectedEvent); 
        }else{
            if(totalOwnership < 100 || totalOwnership>100){
                this.showWarningNotification();
            }
        }
      
    }
    step4Prev(){
        this.isStep3=true;
        const selectedEvent = new CustomEvent("ownership", {
            detail: this.isStep3
            });
          
              // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
    showWarningNotification() {
        const evt = new ShowToastEvent({
            title: "Warning",
            message: "Ownership must total 100%",
            variant: "warning",
            mode: "sticky"
        });
        this.dispatchEvent(evt);
    }
}