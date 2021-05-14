/**
 * Name : ITriggerHandler
 * Description  This is the interface to be implemented by all trigger handler classes.
 *               Simply complete the implemented methods which are required for the trigger. 
 *               Leave any events that you do not need blank.
 */
public interface ITriggerHandler {

    void BeforeInsert(SObject[] newItems);

    void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    void BeforeDelete(Map<Id, SObject> oldItems);

    void AfterInsert(Map<Id, SObject> newItems);

    void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    void AfterDelete(Map<Id, SObject> oldItems);

    void AfterUndelete(Map<Id, SObject> newItems);

}