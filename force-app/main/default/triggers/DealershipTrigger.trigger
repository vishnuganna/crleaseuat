/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger DealershipTrigger on Dealership__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('DealershipTrigger');
  
  if(tStatus.Active__c){ 
      TriggerDispatcher.Run(new DealershipTriggerHandler(), Trigger.operationType);
      //Existing Trigger 'gtDealership' logic
      gcDealershipHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isInsert,
                                        Trigger.isAfter);
  }
}