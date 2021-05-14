public with sharing class legalcaseToast {

    @AuraEnabled(cacheable=true)
    public static list<case> getCaseRelatedToAccount(Id accountid) {
        list<case> csList;
        String sObjName = accountid.getSObjectType().getDescribe().getName();
        if(sObjName == 'Account'){
            csList = [SELECT Id,accountId from case where AccountId = :accountid AND RecordTypeId = '0125G000001E2bSQAS'];
        }
        else if(sObjName == 'Contact')
        {
            csList = [SELECT Id,contactId from case where contactId = :accountid AND RecordTypeId = '0125G000001E2bSQAS'];
        }
        return  csList;
     }
}