/** 
 * Created by Amit Kumar on 4/21/2021.
 * Description The Trigger Framework implemetation for object
 */
trigger AssetTrigger on Asset(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
  Trigger_Manager__mdt tStatus = Trigger_Manager__mdt.getInstance('AssetTrigger');
  
  if(tStatus.Active__c){
      TriggerDispatcher.Run(new AssetTriggerHandler(), Trigger.operationType);
      //Existing Trigger 'gtAsset' logic
      gcAssetHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isAfter);
  }
}