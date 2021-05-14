/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger PPLBusinessOwnerTrigger on PPL_Business_Owner__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('PPLBusinessOwnerTrigger');
  if(tStatus.Active__c){ 
      TriggerDispatcher.Run(new PPLBusinessOwnerTriggerHandler(), Trigger.operationType);
  }
}