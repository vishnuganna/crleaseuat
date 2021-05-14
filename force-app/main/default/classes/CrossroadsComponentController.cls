public class CrossroadsComponentController extends ComponentControllerBase {
    public Lead lead { get; set; }
    public Boolean hasAuthorized { get; set; }
    public Boolean showTermsError { get; set; }

    public CrossroadsComponentController() {
        hasAuthorized = false;
        showTermsError = false;
    }

    @TestVisible
    private static List<SelectOption> getPickListValues(String objectName, String fieldName) {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('', ' -- Select -- '));

        Schema.DescribeSObjectResult[] objectResult = Schema.describeSObjects(new String[] { objectName });
        Schema.DescribeFieldResult fieldDescription = objectResult[0].fields.getMap().get(fieldName).getDescribe();

        List<Schema.PickListEntry> picklistEntries = fieldDescription.getPickListValues();

        for (Schema.PickListEntry pickListEntry : picklistEntries) {
            options.add(new SelectOption(pickListEntry.getValue(), pickListEntry.getLabel()));
        }

        return options;
    }

    @TestVisible
    private static List<SelectOption> getPickListValues(String objectName, String fieldName, String filterBy) {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('', ' -- Select -- '));

        Schema.DescribeSObjectResult[] objectResult = Schema.describeSObjects(new String[] { objectName });
        Schema.DescribeFieldResult fieldDescription = objectResult[0].fields.getMap().get(fieldName).getDescribe();

        List<Schema.PickListEntry> picklistEntries = fieldDescription.getPickListValues();

        for (Schema.PickListEntry pickListEntry : picklistEntries) {
            if (pickListEntry.getValue().contains(filterBy)) {
                options.add(new SelectOption(pickListEntry.getValue(), pickListEntry.getLabel()));
            }
        }

        return options;
    }

    private String createSlug(String text) {
        return text.toLowerCase().trim().replaceAll('[^a-z0-9\\s]+', '').replaceAll('[\\s]+', '-');
    }

    private String getNotificationText() {
        Map<String,String> mappings = new Map<String,String> {
            'Company' => 'Company',
            'FirstName' => 'First Name',
            'LastName' => 'Last Name',
            'Street' => 'Street Address',
            'City' => 'City',
            'State' => 'State',
            'PostalCode' => 'Zip Code',
            'Phone' => 'Business Phone',
            'MobilePhone' => 'Mobile Phone',
            'Email' => 'Email Address',
            'Tax_ID__c' => 'FID/Tax ID',
            'Industry_Experience__c' => 'Years in Business',
            'How_long_have_you_had_your_CDL__c' => 'Years with CDL',
            'Fleet_Size__c' => 'Fleet Size',
            'Preferred_Language__c' => 'Preferred Language'
        };

        NotificationBuilder notificationBuilder = new NotificationBuilder(this.lead, mappings, 'Crossroads');

        return notificationBuilder.getNotification();
    }

    public Boolean sendNotification() {
        String notificationText = getNotificationText();

        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[] { 'nsuarez@crlease.com' };
        String[] ccAddresses = new String[] { 'dnelson@crlease.com' };

        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);

        mail.setSubject('New Lead Submission for ' + this.lead.Company);
        mail.setBccSender(false);
        //mail.setUseSignature(false);

        mail.setPlainTextBody('New Lead Submission for: ' + this.lead.Company);
        mail.setHtmlBody(notificationText);

        // Insert attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        String fileName = createSlug(this.lead.Company + ' ' + this.lead.FirstName + ' ' + this.lead.LastName) + '.pdf';
        efa.setFileName(fileName);
        Blob body = Blob.toPDF(notificationText);
        efa.setBody(body);

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });

        Messaging.SendEmailResult[] mailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        return mailResults[0].isSuccess();
    }

    public List<SelectOption> getLanguages() {
        return getPickListValues('Lead', 'Preferred_Language__c');
    }
}