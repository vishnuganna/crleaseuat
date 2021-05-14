@isTest
public class NotificationBuilderTest {
    @isTest static void testNotification() {
        Lead lead = new Lead();
        String carrierName = 'Panther';

        lead.FirstName = 'David';
        lead.LastName = 'Nelson';
        lead.FCAP__c = true;
        lead.FCAP_Program__c = carrierName;

        Map<String,String> mappings = new Map<String,String> {
            'FirstName' => 'First Name',
            'LastName' => 'Last Name',
            'FCAP_Program__c' => 'FCAP Recruiter'
        };

        NotificationBuilder notificationBuilder = new NotificationBuilder(lead, mappings, carrierName);

        String notificationText = notificationBuilder.getNotification();
        System.assert(!String.isBlank(notificationText), 'Notification text must not be empty.');
    }
}