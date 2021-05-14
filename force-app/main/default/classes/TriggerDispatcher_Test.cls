@isTest
private class TriggerDispatcher_Test {

    @isTest static void TestAccount() {
        Account acc = new Account(Name='Test Account');
        Test.startTest();
        	Database.SaveResult result =  Database.insert(acc);
        Test.stopTest();        
        System.assert(result.isSuccess());
    }
    
	@isTest static void TestCreatePayrollRecord() {
        PPL_Application__c pplApp = new PPL_Application__c();
        pplApp.Delinquent_or_Defaulted_Loan__c = 'No';
        pplApp.Excluded_by_Federal_Agency__c = 'No';
        pplApp.Customer_Source__c = 'VSBA';
        pplApp.Felony__c = 'No';
        pplApp.Form_941_Confirmation__c = 'Yes';
        pplApp.Franchise_Directory__c = 'No';
        pplApp.In_Operation_Before_2_15_2020__c = 'Yes';
        pplApp.Loan_Use_Interest__c= 'Yes';
        pplApp.Loan_Use_Payroll__c = 'Yes';
        pplApp.Loan_Use_Utilities__c = 'Yes';
        pplApp.Not_Engaged_In_Illegal_Activity__c = 'Yes';
        pplApp.Other_LU__c = 'No';
        pplApp.Receieved_Disaster_Loan__c = 'No';
        pplApp.Uncertainty_in_Economy__c = 'Yes';
		pplApp.X500_or_Fewer_FTEs__c = 'Yes';
        pplApp.Other_Business_Affiliations__c = 'No';
        pplApp.Subject_to_Indictment__c = 'No';
        pplApp.US_Principal_Residence__c = 'Yes';
        pplApp.Maintain_Payroll__c = 'Yes';
        
        Test.startTest();
        	Database.SaveResult result =  Database.insert(pplApp);
        Test.stopTest();
        
        System.assert(result.isSuccess());
    }
	
}