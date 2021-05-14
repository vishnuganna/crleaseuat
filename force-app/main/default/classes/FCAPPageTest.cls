@isTest
public class FCAPPageTest {
    private static final String carrierName = 'Panther';
    private static final String cssClassName = 'panther';
    private static final String redirectTo = 'https://panther.crlease.com/thank-you.html';
    private static final String inventoryURL = 'https://www.crlease.com/inventory/panther#/';
    private static final String carrierEmail = 'PantherLTO@crlease.com';

    @isTest
    static void testFCAPController() {
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
        lead.FCAP__c = true;
        lead.FCAP_Program__c = 'Panther';
        lead.FCAP_Recruiter__c = 'Panther - Travia Jones';
        lead.SSN__c = '111-11-1111';

        PageReference pageRef = Page.PantherForm;
        Test.setCurrentPage(pageRef);

        FCAPComponentController compController = new FCAPComponentController();
        PantherController controller = new PantherController();
        controller.setComponentController(compController);
        controller.setRedirect('https//www.crlease.com/');
        compController.hasAuthorized = true;

        controller.lead = lead;

        // Make sure controller is not null
        System.assert(controller != null, 'Controller must not be null.');

        // Make sure Lead created on FCAP Controller is not null
        System.assert(controller.lead != null, 'Lead must have been instantiated.');

        // Make sure getLead doesn't return null
        System.assert(controller.getLead() != null, 'Method cannot return null value.');

        // Make sure getInstance returns an instance of PantherController
        System.assert(controller.getInstance() != null, 'Must return an instance of PantherController');

        // Make sure the correct carrier name is returned
        System.assert(controller.getCarrierName() == carrierName, 'Carrier name must be ' + carrierName);

        // Make sure the correct css class is returned
        System.assert(controller.getCssClassName() == cssClassName, 'CSS Class Name must be ' + cssClassName);

        // Make sure the correct inventory url is returned
        System.assert(controller.getInventoryURL() == inventoryURL, 'Inventory URL must be ' + inventoryURL);

        // Make sure the correct carrier email is returned
        System.assert(controller.getCarrierEmail() == carrierEmail, 'Carrier Email must be ' + carrierEmail);

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
    static void testCDNController() {
        CDNController controller = new CDNController();

        // Make sure getLead doesn't return null
        System.assert(controller.getLead() != null, 'Method cannot return null value.');

        // Make sure getInstance returns an instance of CDNController
        System.assert(controller.getInstance() != null, 'Must return an instance of CDNController');

        // Make sure the correct carrier name is returned
        System.assert(controller.getCarrierName() == 'CDN', 'Carrier name must be CDN');

        // Make sure the correct css class is returned
        System.assert(controller.getCssClassName() == 'cdn', 'CSS Class Name must be cdn');

        // Make sure the correct inventory url is returned
        System.assert(controller.getInventoryURL() == 'https://www.crlease.com/inventory/cdn#/', 'Inventory URL must be https://www.crlease.com/inventory/cdn#/');

        // Make sure the correct carrier email is returned
        System.assert(controller.getCarrierEmail() == 'CDNLTO@crlease.com', 'Carrier Email must be CDNLTO@crlease.com');
    }

    @isTest
    static void testUSATruckController() {
        USATruckController controller = new USATruckController();

        // Make sure getLead doesn't return null
        System.assert(controller.getLead() != null, 'Method cannot return null value.');

        // Make sure getInstance returns an instance of USATruckController
        System.assert(controller.getInstance() != null, 'Must return an instance of USATruckController');

        // Make sure the correct carrier name is returned
        System.assert(controller.getCarrierName() == 'USA Truck', 'Carrier name must be USA Truck');

        // Make sure the correct css class is returned
        System.assert(controller.getCssClassName() == 'usatruck', 'CSS Class Name must be usatruck');

        // Make sure the correct inventory url is returned
        System.assert(controller.getInventoryURL() == 'https://www.crlease.com/inventory/usa#/', 'Inventory URL must be https://www.crlease.com/inventory/usa#/');

        // Make sure the correct carrier email is returned
        System.assert(controller.getCarrierEmail() == 'USATruckLTO@crlease.com', 'Carrier Email must be USATruckLTO@crlease.com');
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