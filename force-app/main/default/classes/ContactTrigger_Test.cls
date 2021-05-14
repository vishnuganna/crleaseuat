@isTest
private class ContactTrigger_Test {
    @isTest static void Testcontact() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        Contact con = new Contact(FirstName='Test',LastName='Contact 1',Accountid=acc.id);
        insert con;
     }
 }