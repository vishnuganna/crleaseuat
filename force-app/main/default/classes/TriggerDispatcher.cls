/**
 * Name : TriggerDispatcher
 * @description  This class runs the appropriate methods on the trigger handler based on the current trigger context.
 * @date Apr 19, 2021
 */
public class TriggerDispatcher {
  public static void Run(ITriggerHandler handler, System.TriggerOperation triggerEvent)
  {
    switch on triggerEvent {
      when BEFORE_INSERT {
        handler.BeforeInsert(trigger.new);
      } when BEFORE_UPDATE {
        handler.BeforeUpdate(trigger.newMap, trigger.oldMap);
      } when BEFORE_DELETE {
        handler.BeforeDelete(trigger.oldMap);
      } when AFTER_INSERT {
        handler.AfterInsert(Trigger.newMap);
      } when AFTER_UPDATE {
        handler.AfterUpdate(trigger.newMap, trigger.oldMap);
      } when AFTER_DELETE {
        handler.AfterDelete(trigger.oldMap);
      } when AFTER_UNDELETE {
        handler.AfterUndelete(trigger.oldMap);
      }
    }  
  }
}