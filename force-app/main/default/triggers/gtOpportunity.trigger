trigger gtOpportunity on Opportunity (after insert, after update,before update) {
    gcOpportunityHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isInsert,
                                        Trigger.isUpdate,
                                        Trigger.isAfter,
                                        Trigger.isBefore);
}