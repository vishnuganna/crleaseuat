@isTest
public class CrossroadsComponentTest {
    @isTest
    static void testComponentController() {
        Lead lead = new Lead();
        lead.Company = 'Test';
        lead.FirstName = 'Test';
        lead.LastName = 'Test';
        lead.DBA__c = 'DBA';
        lead.Street = '123 Main St';
        lead.City = 'Upland';
        lead.State = 'CA';
        lead.PostalCode = '92346';
        lead.Phone = '909-915-0636';
        lead.MobilePhone = '909-915-0636';
        lead.Email = 'pantherlto@crlease.com';
        lead.Tax_ID__c = '0000';
        lead.Industry_Experience__c = 3;
        lead.How_long_have_you_had_your_CDL__c = 10;
        lead.Fleet_Size__c = 3;
        lead.SSN__c = '111-11-1111';

        CrossroadsComponentController controller = new CrossroadsComponentController();

        controller.lead = lead;
        controller.hasAuthorized = true;
        controller.showTermsError = false;

        // Make sure sendNotification is successful
        System.assert(controller.sendNotification() == true, 'Notification must be sent successfully.');
    }
}