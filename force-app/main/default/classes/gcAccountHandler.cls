public without sharing class gcAccountHandler {

    private static final List<String> accountFields = new List<String> {'Applicant_Type__c', 'Years_in_Business__c', 'Years_with_CDL__c',
                                                        'Name', 'EIN__c', 'DBA__c', 'Legal_Structure__c', 'BillingStateCode',
                                                        'Specific_Industry__c', 'Tax_ID__c','Fleet_Size__c',
                                                        'BillingStreet', 'BillingPostalCode', 'BillingCity',
                                                        'Previous_Financing__c', 'Reason_for_Purchase__c', 'Haul_Type__c',
                                                        'Do_You_Haul_HAZMAT__c', 'Annual_Mileage__c', 'Haul_Internationally__c',
                                                        'Majority_in_CA__c', 'Email_Address__c', 'Previous_Financier__c',
                                                        'International_Mileage__c', 'AnnualRevenue', 'NumberOfEmployees',
                                                        'State_Of_Incorporation__c'};

    public static void triggerHandler(Map<Id, Account> oldMap,
                                        Map<Id, Account> newMap,
                                        List<Account> listNew,
                                        Boolean boolIsInsert,
                                        Boolean boolIsUpdate,
                                        Boolean boolIsAfter,
                                        Boolean boolIsBefore) {

        if (boolIsAfter && boolIsUpdate) {
            checkForAspireIntegration(oldMap, listNew);
        }
    }

    private static void checkForAspireIntegration(Map<Id, Account> oldMap, List<Account> listNew) {
        Set<Id> accountIdSet = new Set<Id>();

        for (Account account : listNew) {
            Account oldAccount = oldMap.get(account.Id);
            for (String fieldName : accountFields) {
                if (account.get(fieldName) != oldAccount.get(fieldName)) {
                    accountIdSet.add(account.Id);
                    break;
                }
            }
        }

        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIdSet AND Owner.Profile.Name IN ('System Administrator', 'CELF User')];
        if (!contacts.isEmpty()) {
            for (Contact contact : contacts) {
                contact.IsChangedForAspire__c = true;
            }

            update contacts;
        }
    }
}