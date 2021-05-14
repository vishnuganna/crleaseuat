/** 
 * Created by Nikolai Ivakhnenko on 10/18/19.
 * Updated by : Amit Kumar - Apr 19, 2021 - The trigger Framework implemetation for Lead object
*/

trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
  Trigger_Manager__mdt status = Trigger_Manager__mdt.getInstance('LeadTrigger');
  
  if(status.Active__c){
      TriggerDispatcher.Run(new LeadTriggerHandler(), Trigger.operationType);
  }

}