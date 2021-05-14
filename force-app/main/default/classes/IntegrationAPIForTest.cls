public without sharing  class IntegrationAPIForTest {
    @AuraEnabled
    public static String getExperianData(Account account, Contact contactPrimary, Contact contactSecondary, Id contactPrimaryId, Id contactSecondaryId) {
        gcExperianApi.CreditReportApi api = new gcExperianApi.CreditReportApi();
        String experianToken = api.getExperianToken();
        gcExperianApi.ExperianCreditReportResponse response = api.getCreditReport(contactPrimary, contactSecondary, account, experianToken);
        String responseString = JSON.serialize(response);
        return responseString;
    }
    @AuraEnabled
    public static String getLexisNexisBusinessInstantData(Account accountDetail,Contact contactPrimary) {
        List<contact> contactList=new list<contact>();
        contactList.add(contactPrimary);
        gcLexisNexisApi.InstantIdApi api = new gcLexisNexisApi.InstantIdApi();
        string result = api.sendBusinessLWC(accountDetail, contactList);
        //System.debug(result);
        
        return result;
    }
    @AuraEnabled
    public static String getLexisNexisIndividualData(Contact contactPrimary) {
        gcLexisNexisApi.InstantIdApi api = new gcLexisNexisApi.InstantIdApi();
        string result = api.sendIndividualLWC(contactPrimary);
        //System.debug(result);
        
        return result;
    }
    
    @AuraEnabled
    public static List<gcPayNetDirectAPI.company_wrapper> getPaynetCompaniesData(Account account) {
       
        

        gcPayNetDirectAPI.PayNetDirectSoap api = new gcPayNetDirectAPI.PayNetDirectSoap();
        PayNetSettings__c paynet = PayNetSettings__c.getOrgDefaults();
        gcPayNetDirectAPI.CompanySearchResult_element companySearchResult = api.CompanySearch(
                paynet.UserName__c,
                paynet.Password__c,
                paynet.Version__c,
                account.Name,
                '',
                account.BillingStreet,
                account.BillingCity,
                account.BillingStateCode,
                account.Phone,
                account.Tax_ID__c,
                90,
                '');
        return companySearchResult.response.companies;
    }
    
    
}