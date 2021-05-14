/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to Impacted Customer object.
 */
public class ImpactedCustomerTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {
  
  }

  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
  
  }

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
      
    List<Impacted_Customer__c>  newlyInsertedItems =  [SELECT  Id ,  Upload_Link__c FROM  Impacted_Customer__c WHERE  Id  IN :trigger.new] ; 
    List<string> ids = new List<string>();
     for ( Impacted_Customer__c e  : newlyInsertedItems) { 
    ids.add(e.id); 
    } 
     VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Impacted_Customer__c' ,  'Upload_Link__c' ,  'a0rf4000007cIf1AAE' ,  ids,null );  
     update newlyInsertedItems;
      
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}