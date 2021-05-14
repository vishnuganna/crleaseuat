/**
@date 2021-02-11
@author Mavens
@description Added new fields-Phone and MobilePhone in Contact for sync to Aspire,

@date 2021-02-22  
added Tax_ID__c to Account query for sending to Aspire.
**/

public without sharing class gcContactHandler {

    private static final List<String> contactFields = new List<String> {'LastName', 'FirstName', 'Percent_Ownership__c', 'Years_as_Company_Driver__c',
                                                        'Years_IOO_Experience__c', 'Years_with_CDL__c', 'Is_Additional_Business_Contact__c',
                                                        'SSN__c', 'MailingStreet', 'MailingCity', 'MailingStateCode',
                                                        'MailingPostalCode', 'Opportunity_Role__c', 'coApplicant__c', 'Email','Phone','MobilePhone'};
    private static Boolean isExecuting = false;

    public static void triggerHandler(Map<Id, Contact> oldMap,
                                        Map<Id, Contact> newMap,
                                        List<Contact> listNew,
                                        Boolean boolIsInsert,
                                        Boolean boolIsUpdate,
                                        Boolean boolIsAfter,
                                        Boolean boolIsBefore) {
        if (boolIsAfter && (boolIsInsert || boolIsUpdate)) {
            //Removing Aspire Integration from Triggers
            /*Set<Id> contactIdSet = checkForAspireIntegration(oldMap, listNew, boolIsInsert);
            if (!contactIdSet.isEmpty() && isExecuting != true) {
                isExecuting = true;
                sendToAspire(contactIdSet, boolIsInsert);
            }*/
        }else if (boolIsBefore && (boolIsInsert || boolIsUpdate)) {
            validateFields(listNew);
        }
    }

    private static Set<Id> checkForAspireIntegration(Map<Id, Contact> oldMap, List<Contact> listNew, Boolean boolIsInsert) {
        Set<Id> contactIdSet = new Set<Id>();

        for (Contact contact : listNew) {
            if (boolIsInsert || contact.IsChangedForAspire__c) {
                contactIdSet.add(contact.Id);
            } else if (oldMap != null && oldMap.containsKey(contact.Id)) {
                Contact oldContact = oldMap.get(contact.Id);
                for (String fieldName : contactFields) {
                    if (contact.get(fieldName) != oldContact.get(fieldName)) {
                        contactIdSet.add(contact.Id);
                        break;
                    }
                }
            }
        }

        return contactIdSet;
    }

    @future(callout=true)
    public static void sendToAspire (Set<Id> contactsId, Boolean boolIsInsert) {

        try{
        List<Contact> contacts = [
                SELECT LastName, FirstName,Birthdate, AccountId, Percent_Ownership__c, Years_as_Company_Driver__c,
                        Years_IOO_Experience__c, Years_with_CDL__c, Is_Additional_Business_Contact__c,
                        SSN__c, MailingStreet, MailingCity, MailingStateCode, IsChangedForAspire__c,
                        MailingPostalCode, Opportunity_Role__c, coApplicant__c, Email, Name,Phone,MobilePhone,
                        (SELECT Id, Opportunity.DurationPrimaryHaulSouce__c, Opportunity.Replacement_Equipment__c, Opportunity.Past_Commercial_Finance__c FROM OpportunityContactRoles ORDER BY CreatedDate DESC LIMIT 1)
                FROM Contact
                WHERE  Id IN :contactsId
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
                            Specific_Industry__c,Industry_Code__c,Date_of_Birth__c,Fleet_Size__c,
                            BillingStreet, BillingPostalCode, BillingCity,
                            Previous_Financing__c, Reason_for_Purchase__c, Haul_Type__c,
                            Do_You_Haul_HAZMAT__c, Annual_Mileage__c, Haul_Internationally__c, Majority_in_CA__c,
                            Email_Address__c, Previous_Financier__c, International_Mileage__c, AnnualRevenue,
                            NumberOfEmployees, State_Of_Incorporation__c
                    FROM Account
                    WHERE id IN :accountsId
            ]);

            gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
            //Start Transaction
           // customerApi.startTransaction();
            gcAspireApi.AspireResponse customerApiResponse = new gcAspireApi.AspireResponse();
            gcAspireApi.AspireResponse locationApiResponse = new gcAspireApi.AspireResponse();
            gcAspireApi.AspireResponse udfApiResponse = new gcAspireApi.AspireResponse();
            for (Contact contact: contacts) {
                Account relatedAcc = accountsMap.get(contact.AccountId);
                if (relatedAcc != null && !Test.isRunningTest()) {
                    if (boolIsInsert) {
                        locationApiResponse = customerApi.createLocation(relatedAcc, contact);
                            if((locationApiResponse.Errors.size() == 0)){
                                customerApiResponse = customerApi.createCustomer(relatedAcc, contact);
                            }
                    } else {
                        locationApiResponse = customerApi.updateLocation(relatedAcc, contact);
                            if(locationApiResponse.StatusRespCode == 422){
                                locationApiResponse = customerApi.createLocation(relatedAcc, contact);
                            }
                                if(locationApiResponse.Errors.size() == 0){
                                    customerApiResponse = customerApi.updateCustomer(relatedAcc, contact);
                                    if(customerApiResponse.StatusRespCode == 422){
                                        customerApiResponse = customerApi.createCustomer(relatedAcc, contact);// no location previously existing  
                                    }
                                    
                                    udfApiResponse = customerApi.accountUDFs(relatedAcc, contact);

                                }
                    }
                    if((customerApiResponse.Errors != null && customerApiResponse.Errors.size() > 0)){
                        crossRoadsUtil.insertErrorLogRecord(customerApiResponse.Errors[0].Messages[0],customerApiResponse.Errors[0].Code , 'gcAspire.updateCustomer', 'Error');
                    }
                    else if(locationApiResponse.Errors !=null && locationApiResponse.Errors.size() > 0){
                        crossRoadsUtil.insertErrorLogRecord(locationApiResponse.Errors[0].Messages[0],locationApiResponse.Errors[0].Code , 'gcAspire.updateLocation', 'Error');   
                    }
                    else if(udfApiResponse.Errors !=null && udfApiResponse.Errors.size() > 0){
                           crossRoadsUtil.insertErrorLogRecord(udfApiResponse.Errors[0].Messages[0],udfApiResponse.Errors[0].Code , 'gcAspire.updateUDF', 'Error');      
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

    public static void validateFields(List<Contact> contacts){
        for (Contact con : contacts) {
            con.Percent_Ownership__c = con.Percent_Ownership__c == null ? 0 : con.Percent_Ownership__c;
        }
    }
}