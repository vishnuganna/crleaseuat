/**
 * Created by oputria on 26.10.2020.
 */

trigger gtDealership on Dealership__c (after insert) {
    gcDealershipHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isInsert,
                                        Trigger.isAfter);
}