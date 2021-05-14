/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_Trigger7D0C8 on Impacted_Customer__c
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<Impacted_Customer__c>  newlyInsertedItems =  [SELECT  Id ,  Upload_Link__c FROM  Impacted_Customer__c WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( Impacted_Customer__c e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Impacted_Customer__c' ,  'Upload_Link__c' ,  'a0rf4000007cIf1AAE' ,  ids,null );  
 update newlyInsertedItems;}
}