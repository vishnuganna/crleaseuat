public without sharing class gcOpportunityHandler{

    private static final List<String> opportunityFields = new List<String> {'SalesUserNum__c', 'Finance_Program__c', 'AlreadyInAspire__c', 'StageName', 'Replacement_Equipment__c', 'OwnerId'};
    private static final List<String> opportunityFieldsForContact = new List<String> {'DurationPrimaryHaulSouce__c', 'Replacement_Equipment__c', 'Past_Commercial_Finance__c'};

    public static Boolean isFirstTime= true;
    
    public static void triggerHandler
            (map<Id,Opportunity> oldMap,
                    map<Id,Opportunity> newMap,
                    list<Opportunity> listNew,
                    Boolean boolIsInsert,
                    Boolean boolIsUpdate,
                    Boolean boolIsAfter,
                    Boolean boolIsBefore){
                        if (boolIsBefore && boolIsUpdate) {
                            checkStatusResubmit(oldMap, listNew);
        }

        if (isFirstTime && boolIsAfter && (boolIsInsert || boolIsUpdate)) {
            isFirstTime = false;
            //Removing Aspire Integration from Triggers
            /*Set<Id> filteredByCELF = filterByRecordTypeAndChangedFields(oldMap, listNew, 'CELF');

            if (!filteredByCELF.isEmpty()) {
                sendToAspireForCreateOrUpdate(filteredByCELF);
            }*/

            if (boolIsAfter && boolIsInsert) {
            }

            if (boolIsAfter && boolIsUpdate) {
                createOpportunityContactRoles(listNew);
                checkByRecordTypeAndChangedFieldsForContactSync(oldMap, listNew, 'CELF');
                
            }
        }
    }


    private static void createOpportunityContactRoles(List<Opportunity> opportunities) {
        List<OpportunityContactRole> opportunityContactRoles = new List<OpportunityContactRole>();
        for (Opportunity opportunity :[SELECT Id, OwnerId, Primary_Contact__c, Primary_Contact__r.Opportunity_Role__c,
                                              Referral_Contact__c, Referral_Contact__r.Opportunity_Role__c, Owner.Aspire_ID__c,
                                              (SELECT Id, ContactId, Role FROM OpportunityContactRoles)
                                         FROM Opportunity
                                        WHERE Id IN :opportunities]) {
            Boolean containPrimary = false;
            Boolean containReferral = false;
            for (OpportunityContactRole opportunityContactRole : opportunity.OpportunityContactRoles) {
                if (opportunity.Primary_Contact__c != null && opportunity.Primary_Contact__c == opportunityContactRole.ContactId && opportunityContactRole.Role != 'SalesRep') {
                    containPrimary = true;
                }

                if (opportunity.Referral_Contact__c != null && opportunity.Referral_Contact__c == opportunityContactRole.ContactId) {
                    containReferral = true;
                }
            }

            if (opportunity.Primary_Contact__c != null && !containPrimary) {
                OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
                opportunityContactRole.OpportunityId = opportunity.Id;
                opportunityContactRole.ContactId = opportunity.Primary_Contact__c;
                opportunityContactRole.Role = opportunity.Primary_Contact__r.Opportunity_Role__c;
                opportunityContactRole.IsPrimary = true;
                opportunityContactRoles.add(opportunityContactRole);
            }

            if (opportunity.Referral_Contact__c != null && !containReferral) {
                OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
                opportunityContactRole.OpportunityId = opportunity.Id;
                opportunityContactRole.ContactId = opportunity.Referral_Contact__c;
                opportunityContactRole.Role = opportunity.Referral_Contact__r.Opportunity_Role__c;
                opportunityContactRoles.add(opportunityContactRole);
            }
        }

        if (!opportunityContactRoles.isEmpty()) {
            insert opportunityContactRoles;
        }
    }

    @future(callout=true)
    public static void sendToAspireForCreateOrUpdate (Set<Id> opportunityIds) {
        try {
        
        List<Opportunity> opportunities = [
                SELECT Id, AccountId,Amount, SalesUserNum__c, AlreadyInAspire__c, Title_or_IRP_base_plate_CA__c, //Finance_Program__c,
                       StageName, Replacement_Equipment__c, OwnerId, Majority_in_CA__c, Account.Fleet_Size__c, Owner.Aspire_ID__c,
                        Account.NumberOfEmployees, Account.AnnualRevenue, Rate__c,Term__c, App_Only_Deal__c,
                       (SELECT Id, Asset__r.Year__c, Asset__r.Vehicle_Type__c FROM Opportunity_Assets__r)
                  FROM Opportunity
                 WHERE Id IN :opportunityIds];

        List<Opportunity> createdOpportunities = new List<Opportunity>();
        gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse contractResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccountResp = new gcAspireApi.AspireResponse();

        for (Opportunity opportunity: opportunities) {

           if (opportunity.AlreadyInAspire__c && !Test.isRunningTest()) {
                contractResp = customerApi.updateContract(opportunity);
                if((contractResp.Errors != null && contractResp.Errors.size() > 0)){
                    crossRoadsUtil.insertErrorLogRecord(contractResp.Errors[0].Messages[0],contractResp.Errors[0].Code , 'gcAspire.updateContract', 'Error');
                }

            } else {
                gcAspireApi.AspireResponse response = Test.isRunningTest() == false ? customerApi.createContract(opportunity) : gcAspireApi.testResponse();
                if (response.Result != null && (response.Errors.size() < 1 )) {
                    opportunity.AlreadyInAspire__c = true;
                    opportunity.Aspire_Create_Error_Response__c = '';
                    createdOpportunities.add(opportunity);
                    if (!Test.isRunningTest()) {
                        //customerApi.setRelatedAccount(opportunity.Owner.Aspire_ID__c, 'SalesRep', opportunity.Id);
                        relatedAccountResp = customerApi.setRelatedAccount(String.valueOf(opportunity.Account.Id).left(15), 'SalesRep', opportunity.Id);
                        if((relatedAccountResp.Errors != null && relatedAccountResp.Errors.size() > 0)){
                            crossRoadsUtil.insertErrorLogRecord(relatedAccountResp.Errors[0].Messages[0],relatedAccountResp.Errors[0].Code , 'gcAspire.setRelatedAccount', 'Error');
                        }
                    }
                } else {
                    opportunity.Aspire_Create_Error_Response__c = JSON.serialize(response);
                    crossRoadsUtil.insertErrorLogRecord(response.Errors[0].Messages[0],response.Errors[0].Code , 'gcAspire.createContract', 'Error');
                    //createdOpportunities.add(opportunity);
                }
            }
        }
        //Stop Transactions.
        //customerApi.commitTransaction();
        if (!createdOpportunities.isEmpty()) {
            
            isFirstTime = false;
            update createdOpportunities;
        }
        

    } catch (Exception ex) {
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(100), 'gcOpportunityHandler.sendToAspireForCreateOrUpdate', 'Error');               
    }

    }

    public static Set<Id> filterByRecordTypeAndChangedFields (Map<Id, Opportunity> oldMap, List<Opportunity> listNew, String recordTypeName) {
        Set<Id> filteredOpportunityIds = new Set<Id>();
        Id filteredRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();

        System.debug(oldMap);

        for (Opportunity opportunity: listNew) {
            if (opportunity.RecordTypeId == filteredRTypeId) {
                if (opportunity.AlreadyInAspire__c != true) {
                    filteredOpportunityIds.add(opportunity.Id);
                } else {
                    Opportunity oldOpportunity = oldMap.get(opportunity.Id);

                    for (String fieldName : opportunityFields) {
                        if (opportunity.get(fieldName) != oldOpportunity.get(fieldName)) {
                            filteredOpportunityIds.add(opportunity.Id);
                            break;
                        }
                    }
                }
            }
        }

        System.debug(filteredOpportunityIds);

        return filteredOpportunityIds;
    }

    public static void checkByRecordTypeAndChangedFieldsForContactSync (Map<Id, Opportunity> oldMap, List<Opportunity> listNew, String recordTypeName) {
        Set<Id> filteredOpportunityIds = new Set<Id>();
        Id filteredRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();

        for (Opportunity opportunity: listNew) {
            if (opportunity.RecordTypeId == filteredRTypeId) {
                Opportunity oldOpportunity = oldMap.get(opportunity.Id);

                for (String fieldName : opportunityFieldsForContact) {
                    if (opportunity.get(fieldName) != oldOpportunity.get(fieldName)) {
                        filteredOpportunityIds.add(opportunity.Id);
                        break;
                    }
                }
            }
        }

        List<OpportunityContactRole> opportunityContactRoles = [SELECT Id, ContactId FROM OpportunityContactRole WHERE Opportunity.Id IN :filteredOpportunityIds];
        if (!opportunityContactRoles.isEmpty()) {
            List<Contact> contacts = new List<Contact>();
            Set<Id> contactIds = new Set<Id>();
            for (OpportunityContactRole opportunityContactRole : opportunityContactRoles) {
                if (!contactIds.contains(opportunityContactRole.ContactId)) {
                    contacts.add(new Contact(Id = opportunityContactRole.ContactId, IsChangedForAspire__c = true));
                    contactIds.add(opportunityContactRole.ContactId);
                }
            }

            update contacts;
        }
    }
    
    public static void checkStatusResubmit (Map<Id, Opportunity> oldMap,List<Opportunity> opportunities)   {
        List<opportunity> opp = new List<opportunity>();
        for(Opportunity opportunity: opportunities){
            
            if(opportunity.Status__c  == 'Resubmit to Sales'){
                
                opportunity.StageName = 'Resubmit to Credit';
                
            }
            opp.add(opportunity);
        }
        
    }
    
}