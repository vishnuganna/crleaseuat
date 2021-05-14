@isTest
public class CrossroadsPageTest {
    private static final String redirectTo = 'https://panther.crlease.com/thank-you.html';
    private static final String inventoryURL = 'https://www.crlease.com/inventory/panther#/';

    @isTest
    static void testCrossroadsController() {
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

        PageReference pageRef = Page.PantherForm;
        Test.setCurrentPage(pageRef);

        CrossroadsComponentController compController = new CrossroadsComponentController();
        CrossroadsController controller = new CrossroadsController();
        controller.setComponentController(compController);
        compController.hasAuthorized = true;

        controller.lead = lead;

        // Make sure controller is not null
        System.assert(controller != null, 'Controller must not be null.');

        // Make sure Lead created on Crossroads Controller is not null
        System.assert(controller.lead != null, 'Lead must have been instantiated.');

        // Make sure getLead doesn't return null
        System.assert(controller.getLead() != null, 'Method cannot return null value.');

        // Make sure getInstance returns an instance of CrossroadsController
        System.assert(controller.getInstance() != null, 'Must return an instance of CrossroadsController');

        // Make sure the Lead is saved and returns a PageReference
        System.assert(controller.saveLead() != null, 'Lead must save and return the correct PageReference for redirecting.');

        // Test saveLead when hasAuthorized is false to make sure showTermsError is true
        compController.hasAuthorized = false;
        controller.saveLead();
        System.assert(compController.showTermsError == true, 'showTermsError should return true');

        // Make sure ComponentController doesn't return null
        System.assert(controller.getMyComponentController() != null, 'getComponentController() should not return null');
    }

    @isTest
    static void testBaseControllers() {
        PageControllerBase pageController = new PageControllerBase();
        ComponentControllerBase compController = new ComponentControllerBase();

        pageController.setComponentController(compController);
        compController.pageController = pageController;

        // Make sure you do not get a null Component Controller
        System.assert(pageController.getMyComponentController() != null, 'Component Controller should not be null');

        // Make sure getThis doesn't return null
        System.assert(pageController.getThis() != null, 'getThis() should not return null');

    }
}