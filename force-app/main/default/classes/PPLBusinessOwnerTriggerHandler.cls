/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to PPL Business Owner object.
 */
public class PPLBusinessOwnerTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {
  
  }

  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
  
  }

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
    //Logic from FFPrefill_TriggerD3A26   
    List<PPL_Business_Owner__c>  newlyInsertedItems =  [SELECT  Id ,  Update_Info_URL__c FROM  PPL_Business_Owner__c WHERE  Id  IN :trigger.new] ; 
    List<string> ids = new List<string>();
     for ( PPL_Business_Owner__c e  : newlyInsertedItems) { 
    	ids.add(e.id); 
	 } 
     VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Business_Owner__c' ,  'Update_Info_URL__c' ,  'a0rf4000007cJ6gAAE' ,  ids,null );  
     update newlyInsertedItems;
      
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}