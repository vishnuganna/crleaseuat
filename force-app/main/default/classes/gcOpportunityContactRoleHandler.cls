public without sharing class gcOpportunityContactRoleHandler {

    public static void triggerHandler
            (map<Id,OpportunityContactRole> oldMap,
                    map<Id,OpportunityContactRole> newMap,
                    list<OpportunityContactRole> listNew,
                    Boolean boolIsInsert,
                    Boolean boolIsUpdate,
                    Boolean boolIsAfter){
        System.debug('Trigger Handler for OppyContactRole');
        if (boolIsAfter && boolIsInsert) {
            Set<Id> oppyContactRoleIds = new Set<Id>();
            for (OpportunityContactRole role: listNew) {
                if (!role.IsPrimary && role.ContactId != null && role.OpportunityId != null) { // possibly need to create related acc in ASPIRE
                    oppyContactRoleIds.add(role.Id);
                }
            }
            System.debug(oppyContactRoleIds);
            if (!oppyContactRoleIds.isEmpty()) {
                //Removing ASPIRE integration from Triggers
                /*
                createRelatedAccountsInAspire(oppyContactRoleIds);
                */
            }
        }
    }

    @Future(Callout=true)
    private static void createRelatedAccountsInAspire(Set<Id> oppyContactRoles){
        try {
     
            List<OpportunityContactRole> opportunityContactRoles = [
                SELECT Id, OpportunityId, ContactId, Contact.Opportunity_Role__c,Contact.AccountId
                FROM OpportunityContactRole
                WHERE Id IN :oppyContactRoles
                AND Contact.Owner.Profile.Name IN ('System Administrator', 'CELF User')
        ];
        System.debug(opportunityContactRoles);
        if (opportunityContactRoles.isEmpty()) {
            return;
        }
        gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        for (OpportunityContactRole role: opportunityContactRoles) {
            Contact toUpd = new Contact(
                    Id = role.ContactId,
                    Opportunity_Role__c = role.Contact.Opportunity_Role__c
                    
            );
            System.debug(toUpd);
            System.debug(role.OpportunityId);
            if (!Test.isRunningTest()) {
                relatedAccntResp = customerApi.setRelatedAccount(toUpd, role.OpportunityId);
                if((relatedAccntResp.Errors != null && relatedAccntResp.Errors.size() > 0)){
                    crossRoadsUtil.insertErrorLogRecord(relatedAccntResp.Errors[0].Messages[0],relatedAccntResp.Errors[0].Code , 'gcOpportunityContactRolrHandler.createRelatedAccountsInAspire', 'Error');
                }
            }
        }
    } catch (Exception ex) {
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(150), 'gcOpportunityContactRolrHandler.sendToAspireForCreateOrUpdate', 'Error');               
    }
    }

}