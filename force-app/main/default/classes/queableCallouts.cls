public with sharing class queableCallouts implements Queueable {

    private List<OpportunityContactRole> OpportunityContactRoles;
    private Id OpportunityId;
    public queableCallouts(Id id) {
        this.OpportunityId = id;
        this.opportunityContactRoles = [
            SELECT Id, OpportunityId, ContactId, Contact.Opportunity_Role__c,Contact.AccountId
            FROM OpportunityContactRole
            WHERE OpportunityId = :OpportunityId
            AND Contact.Owner.Profile.Name IN ('System Administrator', 'CELF User')
    ];
        

    }
    public void execute(QueueableContext context) {

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
        
    }
}