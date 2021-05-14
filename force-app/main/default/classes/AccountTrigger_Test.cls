@isTest
private class AccountTrigger_Test {

    @isTest static void TestAccount() {
        Account acc = new Account(Name='Test Account');
        Test.startTest();
        	Database.SaveResult result =  Database.insert(acc);
        Test.stopTest();        
        System.assert(result.isSuccess());
    }
    
}