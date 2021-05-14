public class gcSendToAspireController {

    @AuraEnabled
    public static ResponseDataWrapper getOpptyDetails(Id opportunityId) {
        try{
            ResponseDataWrapper responseData = new ResponseDataWrapper();
            responseData.opptys = [
                    SELECT Id,Name,AccountId,ContactId ,AlreadyInAspire__c,Amount, Term__c, TRAC_Residual__c, Pymt_Frequency__c,
                    Financed_Fees__c, Dealer_Fee__c, Rate__c,StageName,CloseDate
                    FROM Opportunity
                    WHERE id = :opportunityId];
            if(responseData.opptys.size() >0) {       
            String acctId = responseData.opptys[0].AccountId;
            responseData.Accounts =[SELECT Name FROM ACCOUNT WHERE Id = :acctId];
            responseData.contacts = [SELECT Name FROM CONTACT WHERE AccountId = :acctId];
            responseData.StatusRespCode =200;
            }
            return (responseData);
            
} catch (Exception ex){
    System.debug(ex.getMessage());
    throw new AuraHandledException('Error Fetching Opportunity');

}
    }

    public class ResponseDataWrapper {
        @AuraEnabled
        public List<Opportunity> opptys {get;set;}
        @AuraEnabled
        public List<Account> Accounts {get;set;}
        @AuraEnabled
        public List<Contact> contacts {get;set;}
        @AuraEnabled
        public Integer StatusRespCode;

        public ResponseDataWrapper(){
            this.opptys = new List<Opportunity>();
            this.Accounts = new List<Account>();
            this.contacts = new List<Contact>();
            this.StatusRespCode = 1000;
        
        }
    }

    @AuraEnabled
    public static gcAspireApi.AspireResponse sendToAspireForCreateOrUpdate (String opportunityIds) {
        gcAspireApi.AspireResponse response = new gcAspireApi.AspireResponse();
        List<Opportunity> createdOpportunities = new List<Opportunity>();
        gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse contractResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccountResp = new gcAspireApi.AspireResponse();
        System.debug('Opportunity Id Is ' + opportunityIds);
        try {
        List<Opportunity> opportunities = [
                SELECT Id, AccountId,ContactId, SalesUserNum__c, AlreadyInAspire__c, Title_or_IRP_base_plate_CA__c, //Finance_Program__c,
                       StageName, Replacement_Equipment__c, OwnerId, Majority_in_CA__c, Account.Fleet_Size__c, Owner.Aspire_ID__c,
                        Account.NumberOfEmployees, Account.AnnualRevenue, Rate__c,Term__c, App_Only_Deal__c,Amount,
                       (SELECT Id, Asset__r.Year__c, Asset__r.Vehicle_Type__c FROM Opportunity_Assets__r)
                  FROM Opportunity
                 WHERE Id  = :opportunityIds];

        
        for (Opportunity opportunity: opportunities) {

                response = Test.isRunningTest() == false ? customerApi.updateContract(opportunity) : gcAspireApi.testResponse();
                if (response.Result != null && response.Result.Result == 'Commit') {
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
                    createdOpportunities.add(opportunity);
                }
            
        }

        if (!createdOpportunities.isEmpty()) {
            
            update createdOpportunities;
        }
        
    } catch (Exception ex) {
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(100), 'gcOpportunityHandler.sendToAspireForCreateOrUpdate', 'Error');               
    }
    return response;
    }

    @AuraEnabled
    public static gcAspireApi.AspireResponse sendFCAPtoAspireForCreate(String opportunityId,String ContactId,String AccountId) {
        System.debug('received details from Component '+  opportunityId+ 'contact' + ContactId + 'accnt' +AccountId );
        
        gcAspireApi.AspireResponse response = new gcAspireApi.AspireResponse();
        if(opportunityId !=null && ContactId !=null &&  AccountId !=null){
            response = gccDealerPortalFlowController.pushToAspire(AccountId, opportunityId,ContactId, null) ;
        }
        return response;
    }

    @AuraEnabled
    public static gcAspireApi.AspireResponse sendFCAPtoAspireForUpdate(String opportunityId,String ContactId,String AccountId) {
        System.debug('received details from Component '+  opportunityId+ 'contact' + ContactId + 'accnt' +AccountId );
        
        gcAspireApi.AspireResponse response = new gcAspireApi.AspireResponse();
        if(opportunityId !=null && ContactId !=null &&  AccountId !=null){
            response = gccDealerPortalFlowController.pushToAspireforUpdate(AccountId, opportunityId,ContactId, null) ;
        }
        return response;
    }

    @AuraEnabled
    public static String updateOpptyStatus(Id opportunityId){
        System.debug('updateOpptyStatus '+opportunityId );
        String response = '';
        if(opportunityId !=null){
            try{
                Opportunity opptyUpdate =[SELECT Name,AlreadyInAspire__c FROM Opportunity WHERE Id = :opportunityId];
                opptyUpdate.AlreadyInAspire__c = true;
                Database.SaveResult SR = Database.update(opptyUpdate);
                System.debug('After updateOpptyStatus '+SR );
                response = 'ok';
            }catch (Exception ex){
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return response;
    }


    @AuraEnabled
    public static void sendToAspire (String contactsId, Boolean boolIsInsert) {
        try{
        List<Contact> contacts = [
                SELECT LastName, FirstName, AccountId, Percent_Ownership__c, Years_as_Company_Driver__c,
                        Years_IOO_Experience__c, Years_with_CDL__c, Is_Additional_Business_Contact__c,
                        SSN__c, MailingStreet, MailingCity, MailingStateCode, IsChangedForAspire__c,
                        MailingPostalCode, Opportunity_Role__c, coApplicant__c, Email, Name,Phone,MobilePhone,
                        (SELECT Id, Opportunity.DurationPrimaryHaulSouce__c, Opportunity.Replacement_Equipment__c, Opportunity.Past_Commercial_Finance__c FROM OpportunityContactRoles ORDER BY CreatedDate DESC LIMIT 1)
                FROM Contact
                WHERE  Id =:contactsId
                AND Owner.Profile.Name IN ('System Administrator', 'CELF User')];

        if (!contacts.isEmpty()) {
            List<Contact> contactsWithFlag = new List<Contact>();

            Set<Id> accountsId = new Set<Id>();

            for (Contact contact: contacts) {

                if (contact.IsChangedForAspire__c) {
                    contactsWithFlag.add(contact);
                }

                accountsId.add(contact.AccountId);
            }

            Map<Id, Account> accountsMap = new Map<Id, Account>([
                    SELECT Id, Applicant_Type__c,Tax_ID__c, Years_in_Business__c, Years_with_CDL__c,
                            Name, EIN__c, DBA__c, Legal_Structure__c, BillingStateCode,
                            Specific_Industry__c, Fleet_Size__c,
                            BillingStreet, BillingPostalCode, BillingCity,
                            Previous_Financing__c, Reason_for_Purchase__c, Haul_Type__c,
                            Do_You_Haul_HAZMAT__c, Annual_Mileage__c, Haul_Internationally__c, Majority_in_CA__c,
                            Email_Address__c, Previous_Financier__c, International_Mileage__c, AnnualRevenue,
                            NumberOfEmployees, State_Of_Incorporation__c
                    FROM Account
                    WHERE id IN :accountsId
            ]);

            gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
            gcAspireApi.AspireResponse customerApiResponse = new gcAspireApi.AspireResponse();
            gcAspireApi.AspireResponse locationApiResponse = new gcAspireApi.AspireResponse();
            gcAspireApi.AspireResponse udfApiResponse = new gcAspireApi.AspireResponse();
            for (Contact contact: contacts) {
                Account relatedAcc = accountsMap.get(contact.AccountId);
                if (relatedAcc != null && !Test.isRunningTest()) {
                    /*if (boolIsInsert) {
                        locationApiResponse = customerApi.createLocation(relatedAcc, contact);
                            if((locationApiResponse.Errors.size() == 0)){
                                customerApiResponse = customerApi.createCustomer(relatedAcc, contact);
                            }
                    } else {*/
                        locationApiResponse = customerApi.updateLocation(relatedAcc, contact);
                            if(locationApiResponse.StatusRespCode == 422){
                                locationApiResponse = customerApi.createLocation(relatedAcc, contact);
                            }
                                if(locationApiResponse.Errors.size() == 0){
                                    customerApiResponse = customerApi.updateCustomer(relatedAcc, contact);
                                    if(customerApiResponse.StatusRespCode == 422){
                                        customerApiResponse = customerApi.createCustomer(relatedAcc, contact);// no location previously existing  
                                    }

                                }
                    //}
                    if((customerApiResponse.Errors != null && customerApiResponse.Errors.size() > 0)){
                        crossRoadsUtil.insertErrorLogRecord(customerApiResponse.Errors[0].Messages[0],customerApiResponse.Errors[0].Code , 'gcAspire.updateCustomer', 'Error');
                    }
                    else if(locationApiResponse.Errors !=null && locationApiResponse.Errors.size() > 0){
                        crossRoadsUtil.insertErrorLogRecord(locationApiResponse.Errors[0].Messages[0],locationApiResponse.Errors[0].Code , 'gcAspire.updateLocation', 'Error');   
                    }
                    else{
                        udfApiResponse = customerApi.accountUDFs(relatedAcc, contact);
                        if(udfApiResponse.Errors !=null && udfApiResponse.Errors.size() > 0){
                           crossRoadsUtil.insertErrorLogRecord(udfApiResponse.Errors[0].Messages[0],udfApiResponse.Errors[0].Code , 'gcAspire.updateUDF', 'Error');      
                        }
                    }
                }
            }

            if (!contactsWithFlag.isEmpty()) {
                for (Contact contact : contactsWithFlag) {
                    contact.IsChangedForAspire__c = false;
                }

               /*Commented due to exception- 20:39:06.136 (7370164478)|FATAL_ERROR|
               System.AsyncException: Future method cannot be called from a future or batch
                method: gcContactHandler.sendToAspire(Set<Id>, Boolean)
                20:39:06.136 (7371193155)|CODE_UNIT_FINISHED|gtContact on Contact trigger event AfterUpdate|__sfdc_trigger/gtContact
                20:39:06.136 (7394989910)|DML_END|[116]

                 update contactsWithFlag;
               */
            }
        }
    }catch (Exception ex){
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(100), 'gcAspire.SendtoAspire', 'Error');              
    }
    }
}