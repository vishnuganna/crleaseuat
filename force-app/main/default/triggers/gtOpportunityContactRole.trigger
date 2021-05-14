trigger gtOpportunityContactRole on OpportunityContactRole (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    gcOpportunityContactRoleHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isAfter);
}