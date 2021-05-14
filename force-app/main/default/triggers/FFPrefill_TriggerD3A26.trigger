/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_TriggerD3A26 on PPL_Business_Owner__c
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<PPL_Business_Owner__c>  newlyInsertedItems =  [SELECT  Id ,  Update_Info_URL__c FROM  PPL_Business_Owner__c WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( PPL_Business_Owner__c e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Business_Owner__c' ,  'Update_Info_URL__c' ,  'a0rf4000007cJ6gAAE' ,  ids,null );  
 update newlyInsertedItems;}
}