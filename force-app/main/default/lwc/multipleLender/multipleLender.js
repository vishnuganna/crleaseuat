import { LightningElement, track, api } from 'lwc';
import SyndicationDetails_OBJECT from '@salesforce/schema/SyndicationDetails__c';
import multipleLenders from '@salesforce/apex/gccDealerPortalFlowController.multipleLenders';
import Amount_Financed_FIELD from '@salesforce/schema/SyndicationDetails__c.Amount_Financed__c';
import Down_Payment_FIELD from '@salesforce/schema/SyndicationDetails__c.Down_Payment__c';
import Finance_Income_FIELD from '@salesforce/schema/SyndicationDetails__c.Finance_Income__c';
import Vin_s_FIELD from '@salesforce/schema/SyndicationDetails__c.Vin_s__c';
import Sell_Rate_FIELD from '@salesforce/schema/SyndicationDetails__c.Sell_Rate__c';
import Lender_s_Name_FIELD from '@salesforce/schema/SyndicationDetails__c.Lender_s_Name__c';
import Relationship_FIELD from '@salesforce/schema/SyndicationDetails__c.Relationship__c';
import Submission_Result_FIELD from '@salesforce/schema/SyndicationDetails__c.Submission_Result__c';
import Syndication_Notes__FIELD from '@salesforce/schema/SyndicationDetails__c.Syndication_Notes__c';
import Buy_Rate_FIELD from '@salesforce/schema/SyndicationDetails__c.Buy_Rate__c';
import Result_Date_FIELD from '@salesforce/schema/SyndicationDetails__c.Result_Date__c';
import Submitted_Date_FIELD from '@salesforce/schema/SyndicationDetails__c.Submitted_Date__c';
import Term_FIELD from '@salesforce/schema/SyndicationDetails__c.Term__c';
import Total_Selling_Price_FIELD from '@salesforce/schema/SyndicationDetails__c.Total_Selling_Price__c';
import Residual_Balloon_FIELD from '@salesforce/schema/SyndicationDetails__c.Residual_Balloon__c';
import Condition_FIELD from '@salesforce/schema/SyndicationDetails__c.Condition__c';
import Decline_Reason_FIELD from '@salesforce/schema/SyndicationDetails__c.Decline_Reason__c';
import Security_Deposit_FIELD from '@salesforce/schema/SyndicationDetails__c.Security_Deposit__c';
export default class MultipleLender extends LightningElement {
    @track lendernamelist = []; 
    @track index = 0;
    
    @track AmountFinanced = Amount_Financed_FIELD;
    @track DownPayment = Down_Payment_FIELD;
    @track FinanceIncome=Finance_Income_FIELD;
    @track vins=Vin_s_FIELD;
    @track SellRate= Sell_Rate_FIELD;
    @track Lendersname=Lender_s_Name_FIELD;
    @track Relationship=Relationship_FIELD;
    @track submissionResult=Submission_Result_FIELD;
    @track SyndicationNotes=Syndication_Notes__FIELD;
    @track BuyRate=Buy_Rate_FIELD;
    @track ResultDate=Result_Date_FIELD;
    @track SubmittedDate=Submitted_Date_FIELD;
    @track Term=Term_FIELD;
    @track totalprice=Total_Selling_Price_FIELD;
    @track ResidualBallon=Residual_Balloon_FIELD;
    @track Condition=Condition_FIELD;
    @track DeclineReason=Decline_Reason_FIELD;
    @track SecurityDeposit=Security_Deposit_FIELD;
    @track isModalOpen = false;
  

@api showSyndication;
@api selectedOppId;
@api record = {
    Name : '',
    Amount_Financed__c : '',
    Down_Payment__c:'',
    Finance_Income__c:'',
    Vin_s__c:'',
    Sell_Rate__c:'',
    Lender_s_Name__c:'',
    Relationship__c:'',
    Submission_Result__c:'',
    Syndication_Notes__c:'',
    Buy_Rate__c:'',
    Result_Date__c:'',
    Submitted_Date__c:'',
    Term__c:'',
    Total_Selling_Price__c:'',
    Residual_Balloon__c:'',
    Condition__c:'',
    Decline_Reason__c:'',
    Security_Deposit__c:'',




}

lendername = {
  
    Amount_Financed__c  : this.AmountFinanced,
    Down_Payment__c:this.DownPayment,
    Finance_Income__c:this.FinanceIncome,
    Vin_s__c:this.vins,
    Sell_Rate__c:this.SellRate,
    Lender_s_Name__c:this.Lendersname,
    Relationship__c:this.Relationship,
    Submission_Result__c:this.submissionResult,
    Syndication_Notes__c:this.SyndicationNotes,
    Buy_Rate__c:this.BuyRate,
    Result_Date__c:this.ResultDate,
    Submitted_Date__c:this.SubmittedDate,
    Term__c:this.Term,
    Total_Selling_Price__c:this.totalprice,
    Residual_Balloon__c:this.ResidualBallon,
    Condition__c:this.Condition,
    Decline_Reason__c:this.DeclineReason,
    Security_Deposit__c:this.SecurityDeposit,

        key : ''
}

connectedCallback(){ 
    this.index = 1;
    this.lendername.key = 1;
    this.lendernamelist.push(JSON.parse(JSON.stringify(this.lendername)));
}

addRow(){

    this.index++;
    var i = this.index;
    this.lendername.key = 1;
    this.lendernamelist.push(JSON.parse(JSON.stringify(this.lendername)));
}

removeRow(event){
    this.isLoaded = true;
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    if(this.lendernamelist.length>1){
        this.lendernamelist.splice(key, 1);
        this.index--;
        this.isLoaded = false;
    }else if(this.lendernamelist.length == 1){
        this.lendernamelist = [];
        this.index = 0;
        this.isLoaded = false;
    }
}



  

handleAmountChange(event){
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Amount_Financed__c = event.target.value;
}

handleLenderChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Lender_s_Name__c = event.detail.selectedValue;
}

handlenotesChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Syndication_Notes__c = event.target.value;
}
handlevinChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Vin_s__c = event.target.value;
}
handledownpaymentChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Down_Payment__c = event.target.value;
}
handleFixedIncomeChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Finance_Income__c = event.target.value;
}

handleSellrateChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Sell_Rate__c = event.target.value;
}
handlebuyRateChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Buy_Rate__c = event.target.value;
}
handleRelationshipStatusChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Relationship__c = event.detail.selectedValue;
}
handleSubmissionChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Submission_Result__c = event.detail.selectedValue;
}
handleResutDateChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Result_Date__c = event.target.value;
}
handlesubmitdateChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Submitted_Date__c = event.target.value;
}
handleTermChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Term__c = event.target.value;
}
handlesellpriceChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Total_Selling_Price__c = event.target.value;
}
handleDeclineChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Decline_Reason__c = event.target.value;
}
handleSecurityChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Security_Deposit__c = event.target.value;
}
handleResidualChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Residual_Balloon__c = event.detail.selectedValue;
}
handleConditionChange(event) {
    
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    var accountVar = this.lendernamelist[key];
    this.lendernamelist[key].Condition__c = event.detail.selectedValue;
}



save(){    
    console.log('I am  coming'+ JSON.stringify(this.lendernamelist));
    console.log('syndication'+this.showSyndication);
    //console.log('opportunity is coming'+selectedOppId);

  
        multipleLenders({  'lenderdata': this.lendernamelist, 'opportunityId': this.selectedOppId
           })
            .then(result => {
                
                
                console.log(JSON.stringify(result));
              
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                
                console.log("error", JSON.stringify(this.error));
            });;
            const synd =this.showSyndication = false;
            const syndChangeEvent = new CustomEvent('syndchange', {detail: {synd}})
            this.dispatchEvent(syndChangeEvent);
    }

    cancel(){
        
        console.log('syndicationclose 1' +this.showSyndication);
        const synd =this.showSyndication = false;
        const syndChangeEvent = new CustomEvent('syndchange', {detail: {synd}})
        this.dispatchEvent(syndChangeEvent);
        console.log('syndicationclose 2' +this.showSyndication);
    }
}