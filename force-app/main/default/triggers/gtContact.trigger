trigger gtContact on Contact (before insert, after insert, before update, after update) {
    gcContactHandler.triggerHandler(Trigger.oldMap,
                                    Trigger.newMap,
                                    Trigger.new,
                                    Trigger.isInsert,
                                    Trigger.isUpdate,
                                    Trigger.isAfter,
                                    Trigger.isBefore);
}