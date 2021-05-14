import { api, wire, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCaseList from '@salesforce/apex/legalcaseToast.getCaseRelatedToAccount';

export default class LegalToast extends LightningElement {

    @api recordId;
    @track isModalOpen = false;
    @track caseRecord;
    @wire(getCaseList,{ accountid: '$recordId'})
    
   accountsData({ error, data }) {
    
       if (data) {
         this.caseRecord = data;
         if(this.caseRecord.length >0){
          
          this.isModalOpen = true;

          console.log(this.isModalOpen) 
          
    }

       } else if (error) {

       }
       
}
    closeHandler(){
        this.isModalOpen = false;
         
}
}