/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger OpportunityContactRoleTrigger on OpportunityContactRole(before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('OpportunityContactRoleTrigger');
  if(tStatus.Active__c){ 
      TriggerDispatcher.Run(new OpportunityContactRoleTriggerHandler(), Trigger.operationType);
      //From Trigger gtOpportunityContactRole 
       gcOpportunityContactRoleHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isAfter);
  }
}