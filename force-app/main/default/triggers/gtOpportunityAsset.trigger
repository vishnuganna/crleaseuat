/**
 * Created by oputria on 27.10.2020.
 */

trigger gtOpportunityAsset on Opportunity_Asset__c (after insert) {
    gcOpportunityAssetHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isAfter);
}