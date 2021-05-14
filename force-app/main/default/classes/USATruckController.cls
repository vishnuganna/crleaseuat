public with sharing class USATruckController extends FCAPController {
    private final String carrierName = 'USA Truck';
    private final String cssClassName = 'usatruck';
    private final String redirectTo = 'https://usatruck.crlease.com/thank-you.html';
    private final String inventoryURL = 'https://www.crlease.com/inventory/usa#/';
    private final String carrierEmail = 'USATruckLTO@crlease.com';

    public USATruckController() {
        lead.FCAP_Program__c = carrierName;
        super.setRedirect(this.redirectTo);
    }

    public Lead getLead() {
        return lead;
    }

    public USATruckController getInstance() {
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