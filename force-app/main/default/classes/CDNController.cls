public with sharing class CDNController extends FCAPController {
    private final String carrierName = 'CDN';
    private final String cssClassName = 'cdn';
    private final String redirectTo = 'https://cdn.crlease.com/thank-you.html';
    private final String inventoryURL = 'https://www.crlease.com/inventory/cdn#/';
    private final String carrierEmail = 'CDNLTO@crlease.com';

    public CDNController() {
        lead.FCAP_Program__c = carrierName;
        super.setRedirect(redirectTo);
    }

    public Lead getLead() {
        return lead;
    }

    public CDNController getInstance() {
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