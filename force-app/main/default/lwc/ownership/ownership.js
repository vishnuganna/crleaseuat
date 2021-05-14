import { LightningElement,api, track } from 'lwc';
import Ownership_OBJECT from '@salesforce/schema/Ownership__c';

export default class Ownership extends LightningElement {
    keyIndex = 0;
    @api item;
    @api ownership=[];
    @track  isCustomerInfo=false;
    isCitizenship=false;
    isOwnership=false;
    ownershipList=[];
    @track ownershipRecord=Ownership_OBJECT;
    
    
   
    handleCountryCitizenshipChange(event){
        this.ownershipRecord.Country__c=event.detail.selectedValue;
       
    }
    handleOwnershipChange(event){
        if(event.target.value<=19){
            this.isOwnership=true;
            this.ownershipRecord.Ownership__c=event.target.value;
        }else{
            this.isOwnership=false;
            this.ownershipRecord.Ownership__c=event.target.value;
        }
    }
    handleBusinessOwnerChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.Name=event.target.value;
    }
    handleHomeAddressChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.Home_Address__c=event.target.value;
    }
    
    handleCityChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.City__c=event.target.value;
    }
    handleDateBirthChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.Date_of_Birth__c=event.target.value;
    }
    handleSSNChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.SSN__c=event.target.value;
    }
    handleStateChange(event){
        this.ownershipRecord.State__c=event.target.selectedValue;
    }
    handleZipChange(event){
        if(event.target.value!=null)
            this.ownershipRecord.Zip__c=event.target.value;
            
    }
    handleCitizenshipStatusChange(event){
      
        if(event.detail.selectedValue!='US Citizen'){
            this.isCitizenship=true;
            this.ownershipRecord.Citizenship_Status__c=event.detail.selectedValue;
            const selectedEvent = new CustomEvent("ownership", {
                    detail: this.ownershipRecord
                });
              
                  // Dispatches the event.
            this.dispatchEvent(selectedEvent);

        
           
        }else{
            this.isCitizenship=false;
            this.ownershipRecord.Citizenship_Status__c=event.detail.selectedValue;
            const selectedEvent = new CustomEvent("ownership", {
                detail: this.ownershipRecord
                });
              
                  // Dispatches the event.
            this.dispatchEvent(selectedEvent);

            
            
            
            
            
        }
    }
}