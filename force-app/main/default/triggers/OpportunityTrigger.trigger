/** 
 * Created by Nikolai Ivakhnenko on 10/18/19.
 * Updated by : Amit Kumar - Apr 19, 2021 - The trigger Framework implemetation for Opportunity object
 */

trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
  Trigger_Manager__mdt tstatus = Trigger_Manager__mdt.getInstance('OpportunityTrigger');
  
  if(tstatus.Active__c){
      TriggerDispatcher.Run(new OpportunityTriggerHandler(), Trigger.operationType);
      //From Trigger OppTrigger
      //oppTriggerHelper.setSSN(Trigger.new, Trigger.operationType);
      
      //From Trigger gtOpportunity
      gcOpportunityHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isInsert,
                                        Trigger.isUpdate,
                                        Trigger.isAfter,
                                        Trigger.isBefore);
    }
}