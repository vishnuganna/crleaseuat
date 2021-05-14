trigger gtApplication on Application__c (before update) {
    gcApplicationHandler.triggerHandler(Trigger.oldMap,
                                        Trigger.newMap,
                                        Trigger.new,
                                        Trigger.isBefore,
                                        Trigger.isInsert,
                                        Trigger.isUpdate,
                                        Trigger.isDelete);
}