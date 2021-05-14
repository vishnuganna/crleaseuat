public without sharing class gcExperianReportController {
    private final Contact contact;

    public gcExperianApi.ExperianCreditReportResponse report {get; set;}

    public gcExperianReportController (ApexPages.StandardController controller) {
//        System.debug([SELECT Experian_Report__c FROM Contact WHERE Id = :controller.getRecord().Id LIMIT 1]);
//        System.debug(this.contact);
        this.contact = [SELECT Experian_Report__c FROM Contact WHERE Id = :controller.getRecord().Id LIMIT 1];
        System.debug(ApexPages.currentPage().getParameters().get('report'));
        String jsonString;
        if (this.contact.Experian_Report__c == null && ApexPages.currentPage().getParameters().get('report') != null) {
            jsonString = ApexPages.currentPage().getParameters().get('report').replace('<p>', '').replace('</p>', '').replace('&quot;', '"').replace('"number"', '"number_x"').replace('"date"', '"date_x"');

        } else if (this.contact.Experian_Report__c != null) {
            jsonString = this.contact.Experian_Report__c.replace('<p>', '').replace('</p>', '').replace('&quot;', '"').replace('"number"', '"number_x"').replace('"date"', '"date_x"');
        }
        System.debug(jsonString);
        this.report = jsonString == null ? new gcExperianApi.ExperianCreditReportResponse() : (gcExperianApi.ExperianCreditReportResponse) JSON.deserialize(jsonString, gcExperianApi.ExperianCreditReportResponse.class);
    }
}