public virtual class FCAPController extends PageControllerBase {
    public FCAPComponentController controller { get; set; }
    public Lead lead { get; set; }

    private String redirectTo;
    private final String PROD_REC_TYPE_ID = '012f4000000b9HQAAY';
    private final String DEV_REC_TYPE_ID = '0120m000000OFLbAAO'; 
    private final String PROD_OWNER_ID = '005f4000004WPww';
    private final String DEV_OWNER_ID = '0050m000002WYyh';

    public FCAPController() {
        lead = new Lead();
        lead.FCAP__c = true;

        lead.recordTypeId = PROD_REC_TYPE_ID;
        lead.ownerId = PROD_OWNER_ID;

        if (!IsProductionOrg()) {
            lead.recordTypeId = DEV_REC_TYPE_ID;
            lead.ownerId = DEV_OWNER_ID;
        }

        if (Test.isRunningTest()) {
            this.redirectTo = 'https//www.crlease.com/';
        }
    }

    /*public void setLeadProps(String ownerId, String carrierName, String recordTypeId, String redirectTo) {
        lead.OwnerId = ownerId;        
        lead.FCAP_Program__c = carrierName;
        lead.RecordTypeId = recordTypeId;

        this.redirectTo = redirectTo;
    }*/

    public void setRedirect(String redirectTo) {
        this.redirectTo = redirectTo;
    }

    public virtual PageReference saveLead() {
        PageReference pageReference = null;

        if (!controller.hasAuthorized) {
            controller.showTermsError = true;
            lead.SSN__C = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must agree'));
            return pageReference;
        }

        try {
            upsert lead;
            controller.sendNotification();

            pageReference = new PageReference(this.redirectTo);
            pageReference.SetRedirect(true);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));

            //pageReference = Page.Exception;
            pageReference = ApexPages.currentPage();
            pageReference.SetRedirect(false);
        }

        return pageReference;
    }

    public override void setComponentController(ComponentControllerBase compController) {
        controller = (FCAPComponentController)compController;
    }

    public override ComponentControllerBase getMyComponentController() {
        return controller;
    }

    private Boolean IsProductionOrg() {
        Organization org = [SELECT IsSandbox FROM Organization WHERE Id =:UserInfo.getOrganizationId()];
        return (org.IsSandbox == true) ? false : true;
    }
}