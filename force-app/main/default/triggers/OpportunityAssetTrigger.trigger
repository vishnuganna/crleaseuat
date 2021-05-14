/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger OpportunityAssetTrigger on Opportunity_Asset__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('OpportunityAssetTrigger');
  if(tStatus.Active__c){ 
      TriggerDispatcher.Run(new OpportunityAssetTriggerHandler(), Trigger.operationType);
      //Existing Trigger 'gtOpportunityAsset' logic
      gcOpportunityAssetHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isAfter);
  }
}