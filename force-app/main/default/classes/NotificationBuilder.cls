public class NotificationBuilder {
    private final Lead lead;
    private final Map<String, String> mappings;
    private final String pageTitle;

    public NotificationBuilder(Lead lead, Map<String,String> mappings, String pageTitle) {
        this.lead = lead;
        this.mappings = mappings;
        this.pageTitle = pageTitle;
    }

    public String getNotification() {
        List<String> notificationText = new List<String>();
        notificationText.Add(String.Format('<h1>{0}</h1><hr />', new List<Object> { this.pageTitle }));

        for (String key : mappings.keySet()) {
            notificationText.Add(String.Format('<p><strong>{0}</strong>: {1}</p>', new List<Object> { mappings.get(key), this.lead.get(key) }));
        }

        // Add time the form was submitted
        notificationText.Add(String.Format('<p>User accepted terms on {0} from {1}<p>', new List<Object> { DateTime.now().format(), getUserIpAddress() }));

        notificationText.Add(URL.getOrgDomainUrl().toExternalForm() + '/' + this.lead.id);

        return String.Join(notificationText, '');
    }

    private String getUserIpAddress() {
        String ipAddress = '';

        ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');

        if (String.isEmpty(ipAddress)) {
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } // get IP address when no caching (sandbox, dev, secure urls)

        system.debug('USER IP ADDRESS: ' + ipAddress);

        return ipAddress;
    }
}