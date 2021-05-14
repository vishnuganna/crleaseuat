/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger ApplicationTrigger on Application__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('ApplicationTrigger');
  
  if(tStatus.Active__c){
      TriggerDispatcher.Run(new ApplicationTriggerHandler(), Trigger.operationType);
      //Existing Trigger 'gtApplication' logic
      gcApplicationHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isBefore,
                                        Trigger.isInsert,
                                        Trigger.isUpdate,
                                        Trigger.isDelete);
  }
}