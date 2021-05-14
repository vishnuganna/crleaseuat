/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to Opportunity object.
 */
public class OpportunityTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {
   // oppTriggerHelper.setSSN(Trigger.new, Trigger.operationType);
  }

  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    //oppTriggerHelper.setSSN(Trigger.new, Trigger.operationType);
  }

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
      //From Trigger -FFPrefill_Trigger090FA   
      List<Opportunity>  newlyInsertedItems =  [SELECT  Id ,  Prefill_URL__c FROM  Opportunity WHERE  Id  IN :trigger.new] ; 
        List<string> ids = new List<string>();
         for ( Opportunity e  : newlyInsertedItems) { 
        ids.add(e.id); 
        } 
         VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Opportunity' ,  'Prefill_URL__c' ,  'a0rf4000005CS56AAG' ,  ids,null );  
         update newlyInsertedItems;     
      
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}