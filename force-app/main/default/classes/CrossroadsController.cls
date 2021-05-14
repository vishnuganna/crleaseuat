public virtual class CrossroadsController extends PageControllerBase {
    public CrossroadsComponentController controller { get; set; }
    public Lead lead { get; set; }

    private final String PROD_REC_TYPE_ID = '012f4000000b9HQAAY';
    private final String DEV_REC_TYPE_ID = '0120m000000OFLbAAO'; 
    private final String PROD_OWNER_ID = '005f4000004WPvA'; // Nelson Suarez
    private final String DEV_OWNER_ID = '0050m000001Gnsl'; // David Nelson
    private final String redirectTo = 'https://www.crlease.com/sites/default/files/app-submitted.html';
    private final String DEFAULT_LEAD_SOURCE = 'Express Credit Application';

    public CrossroadsController() {
        lead = new Lead();

        lead.recordTypeId = PROD_REC_TYPE_ID;
        lead.ownerId = PROD_OWNER_ID;
        if (ApexPages.currentPage().getParameters().get('ls') == null) {
            lead.LeadSource = DEFAULT_LEAD_SOURCE;
        }
        else {
            //lead.LeadSource = 'Express Credit Application';
            lead.LeadSource = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('ls'), 'UTF-8');
        }

        if (!IsProductionOrg()) {
            lead.recordTypeId = DEV_REC_TYPE_ID;
            lead.ownerId = DEV_OWNER_ID;
        }

        if (Test.isRunningTest()) {
            //this.redirectTo = 'https//www.crlease.com/';
        }
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
            if (lead.Company == null) {
                lead.Company = lead.FirstName + ' ' + lead.LastName;
            }

            upsert lead;
            controller.sendNotification();

            pageReference = new PageReference(this.redirectTo);
            pageReference.SetRedirect(true);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            pageReference = ApexPages.currentPage();
            pageReference.SetRedirect(false);
        }

        return pageReference;
    }

    public override void setComponentController(ComponentControllerBase compController) {
        controller = (CrossroadsComponentController)compController;
    }

    public override ComponentControllerBase getMyComponentController() {
        return controller;
    }

    public Lead getLead() {
        return lead;
    }

    public CrossroadsController getInstance() {
        return this;
    }

    private Boolean IsProductionOrg() {
        Organization org = [SELECT IsSandbox FROM Organization WHERE Id =:UserInfo.getOrganizationId()];
        return (org.IsSandbox == true) ? false : true;
    }
}