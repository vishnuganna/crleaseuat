/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to Lead object.
 */
public class LeadTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {}
  
  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
      //CreditAppTriggerHelper.SendLeadsToStaging(newItems);
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}