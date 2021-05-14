trigger gtAccount on Account (after insert, after update) {
    gcAccountHandler.triggerHandler(Trigger.oldMap,
                                    Trigger.newMap,
                                    Trigger.new,
                                    Trigger.isInsert,
                                    Trigger.isUpdate,
                                    Trigger.isAfter,
                                    Trigger.isBefore);
}