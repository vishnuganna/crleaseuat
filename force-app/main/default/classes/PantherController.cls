public class PantherController extends FCAPController {
    private final String carrierName = 'Panther';
    private final String cssClassName = 'panther';
    private final String redirectTo = 'https://panther.crlease.com/thank-you.html';
    private final String inventoryURL = 'https://www.crlease.com/inventory/panther#/';
    private final String carrierEmail = 'PantherLTO@crlease.com';

    public PantherController() {
        lead.FCAP_Program__c = carrierName;
        super.setRedirect(redirectTo);
    }

    public Lead getLead() {
        return lead;
    }

    public PantherController getInstance() {
        return this;
    }

    public String getCarrierName() {
        return carrierName;
    }

    public String getCssClassName() {
        return cssClassName;
    }

    public String getInventoryUrl() {
        return inventoryURL;
    }

    public String getCarrierEmail() {
        return carrierEmail;
    }
}