/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_TriggerC4A02 on PPL_Payroll__c
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<PPL_Payroll__c>  newlyInsertedItems =  [SELECT  Id ,  Final_Payroll_Link__c FROM  PPL_Payroll__c WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( PPL_Payroll__c e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Payroll__c' ,  'Final_Payroll_Link__c' ,  'a0rf4000004dM2rAAE' ,  ids,null );  
 update newlyInsertedItems;}
}