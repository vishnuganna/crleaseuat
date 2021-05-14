/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_Trigger5DFC8 on PPL_Application__c
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<PPL_Application__c>  newlyInsertedItems =  [SELECT  Id ,  Survey_Link__c FROM  PPL_Application__c WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( PPL_Application__c e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Application__c' ,  'Survey_Link__c' ,  'a0rf4000004eEBgAAM' ,  ids,null );  
 update newlyInsertedItems;}
}