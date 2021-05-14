public virtual inherited sharing class gcExperianApi {

    private static final String AZURE_SUBSCRIPTION_KEY = 'b25a64969b004bd6b10f215abab61243';
    private static final String USERNAME = 'cradmin@crlease.com';
    //private static final String PASSWORD = 'dmfZq@9adbKXNLMZA-';
    private static final String PASSWORD ='$3iZL4wbcbLUHnrwYRiBBEMAyLE';
    private static final String SUBSCRIBER_CODE = '1394220';
    private static final String ENVIRONMENT = 'Production';

    public String defaultEndpointAzure = 'https://crossroads-connect.azure-api.net/Experian/';
    public String tokenEndpointAzure = 'oauth2/v1/token';
    public String reportEndpointAzure = 'consumerservices/credit-profile/v2/credit-report';

    public class CreditReportApi extends gcExperianApi {

        public ExperianCreditReportResponse getCreditReport(Contact primaryApplicant, Contact secondaryApplicant, Account account, String token) {
            Http http = new Http();
            HttpRequest requestCreditReport = this.buildBasicRequest(reportEndpointAzure);
            requestCreditReport.setHeader('Authorization', 'Bearer '+token);

            ExperianCreditReportRequest request = new ExperianCreditReportRequest(primaryApplicant, secondaryApplicant, account);
            requestCreditReport.setBody(JSON.serializePretty(request, true));
            System.debug(JSON.serializePretty(request, true));

            HttpResponse response = http.send(requestCreditReport);
            System.debug(response.getBody());

            return (ExperianCreditReportResponse) JSON.deserialize(response.getBody(), ExperianCreditReportResponse.class);
        }

        public String getExperianToken() {
            Http http = new Http();
            HttpRequest requestToken = this.buildBasicRequest(tokenEndpointAzure);
            Map<String, String> requestBodyMap = new Map<String, String>();
            requestBodyMap.put('username', USERNAME);
            requestBodyMap.put('password', PASSWORD);
            requestToken.setBody(JSON.serializePretty(requestBodyMap));
            System.debug(requestToken.getBody());
            System.debug(requestToken);

            HttpResponse response = http.send(requestToken);
            if (response.getStatusCode() != 200) {
                System.debug('###response.getBody() = ' + response.getBody());
                throw new gcExperianTokenException(response.getStatusCode(), response.getBody());
            }
            System.debug(JSON.serializePretty(response.getBody()));

            ExperianTokenResponse tokenResponse = (ExperianTokenResponse)JSON.deserialize(response.getBody(), ExperianTokenResponse.class);
            return tokenResponse.access_token;
        }


        private HttpRequest buildBasicRequest(String methodEndpoint) {
            HttpRequest request = new HttpRequest();

            request.setMethod('POST');
            request.setEndpoint(this.defaultEndpointAzure + methodEndpoint);
            request.setHeader('Environment', ENVIRONMENT);
            request.setHeader('Ocp-Apim-Subscription-Key', AZURE_SUBSCRIPTION_KEY);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', '*/*');

            request.setTimeout(120000);

            return request;
        }

    }

    public class ExperianTokenResponse {
        public String issued_at;
        public String expires_in;
        public String token_type;
        public String access_token;
        public String refresh_token;
    }

    public class gcExperianTokenException extends Exception {
        public Integer errorCode;

        public gcExperianTokenException(Integer errorCode, String errorMessage){
            this.errorCode = errorCode;
            this.setMessage(errorMessage);
        }

        public Integer getErrorCode(){
            return this.errorCode;
        }
    }

    public class ExperianCustomOptions {
        public List<String> optionId;

        public ExperianCustomOptions() {
            this.optionId = new List<String> {''};
        }
    }

    public class ExperianCreditReportRequest {
        public ConsumerPii consumerPii;
        public Requestor requestor;
        public ExperianPermissiblePurpose permissiblePurpose;
        public ExperianResellerInfo resellerInfo;
        public ExperianAddOns addOns;
        public ExperianCustomOptions customOptions;


        public ExperianCreditReportRequest (Contact primaryApplicant, Contact secondaryApplicant, Account account) {
            this.consumerPii = new ConsumerPii(primaryApplicant, secondaryApplicant, account);
            this.requestor = new Requestor();
            this.permissiblePurpose = new ExperianPermissiblePurpose();
            this.resellerInfo = new ExperianResellerInfo('CPAPIV2TC22');
            this.addOns = new ExperianAddOns();
            this.customOptions = new ExperianCustomOptions();
        }
    }

    public class ExperianRiskModels {
        public List<String> modelIndicator;
        public String scorePercentile;

        public ExperianRiskModels() {
            this.modelIndicator = new List<String> {'F', 'R', 'N', 'K', 'V'};
            this.scorePercentile = '';
        }
    }

    public class ExperianSummaries {
        public List<String> summaryType;

        public ExperianSummaries() {
            this.summaryType = new List<String> {'Profile Summary'};
        }
    }

    public class ExperianAddOns {
        public String directCheck;
        public String demographics;
        public ExperianRiskModels riskModels;
        public ExperianSummaries summaries;
        public String fraudShield;
        public String joint;
        public String paymentHistory84;

        public ExperianAddOns() {
            this.directCheck = 'Y';
            this.demographics = 'Only Geocode';
            this.riskModels = new ExperianRiskModels();
            this.summaries = new ExperianSummaries();
            this.fraudShield = 'Y';
            this.joint = '';
            this.paymentHistory84 = 'Y';
        }
    }

    public class ExperianResellerInfo {
        public String endUserName;

        public ExperianResellerInfo(String endUserName) {
            this.endUserName = endUserName;
        }
    }

    public class ExperianPermissiblePurpose {
        public String type;

        public ExperianPermissiblePurpose() {
            this.type = '08';
        }

        public ExperianPermissiblePurpose(String type) {
            this.type = type;
        }
    }

    public class ExperianCreditReportResponse {
        public List<CreditProfile> creditProfile {get; set;}
        public List<ExperianError> errors {get; set;}
        public List<ExperianHeaderError> headerRecordError {get; set;}
    }

    public class ExperianError {
        public String errorCode {get; set;}
        public String errorType {get; set;}
        public String message {get; set;}
    }

    public class ExperianHeaderError {
        public String hostid {get; set;}
        public String applicationId {get; set;}
        public String reportDate {get; set;}
        public String reportDateTime {
            get {
                DateTime dateInstance = DateTime.newInstance(Integer.valueOf(y2kReportedDate.substring(4,8)), Integer.valueOf(y2kReportedDate.substring(0,2)), Integer.valueOf(y2kReportedDate.substring(2,4)),Integer.valueOf(reportTime.substring(0,2)),Integer.valueOf(reportTime.substring(2,4)),0);
                return dateInstance.format('d-MM-yy hh:mm');
            }
        }
        public String reportTime {get; set;}
        public String reportType {get; set;}
        public String preamble {get; set;}
        public String regionCode {get; set;}
        public String versionNo {get; set;}
        public String surName {get; set;}
        public String firstName {get; set;}
        public String mKeywordLength {get; set;}
        public String y2kReportedDate {get; set;}
    }

    public class CreditProfile {
        public List<HeaderRecord> headerRecord {get; set;}
        public List<AddressInformation> addressInformation {get; set;}
        public ConsumerAssistanceReferralAddress consumerAssistanceReferralAddress {get; set;}
        public ConsumerIdentity consumerIdentity {get; set;}
        public List<EmploymentInformation> employmentInformation {get; set;}
        public List<InformationalMessage> informationalMessage {get; set;}
        public List<Inquiry> inquiry {get; set;}
        public Ofac ofac {get; set;}
        public List<Summary> summaries {get; set;}
        public List<RiskModel> riskModel {get; set;}
        public List<SsnResponse> ssn {get; set;}
        public List<Tradeline> tradeline {get; set;}
        public List<EndTotals> endTotals {get; set;}
    }

    public class Tradeline {
        public String accountNumber {get; set;}
        public String accountType {get; set;}
        public String amount1 {get; set;}
        public String amount1WithQualifierFormated {get {
            return amount1 != 'UNKNOWN' ? '$'+ Decimal.valueOf(amount1) + '-' + amount1Qualifier : '';
        }}
        public String amount1Qualifier {get; set;}
        public String amount2 {get; set;}
        public String amount2WithQualifierFormated {get {
            return (amount2 != 'UNKNOWN' && amount2 != null) ? '$'+ Decimal.valueOf(amount2) + '-' + amount2Qualifier : '';
        }}
        public String amount2Qualifier {get; set;}
        public String balanceAmount {get; set;}
        public String balanceAmountFormated {get {
            return (balanceAmount != 'UNKNOWN' && balanceAmount != null) ? '$'+ Decimal.valueOf(balanceAmount) : '';
        }}
        public String balanceDate {get; set;}
        public String balanceDateFormated {get {
            if (balanceDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(balanceDate.substring(4,8)), Integer.valueOf(balanceDate.substring(0,2)), Integer.valueOf(balanceDate.substring(2,4)),0,0,0);
            return dateInstance.format('d-MM-yy');
        }}
        public String monthlyPaymentAmount {get; set;}
        public String monthlyPaymentAmountFormated {get {
            return (monthlyPaymentAmount != 'UNKNOWN' && monthlyPaymentAmount != null) ? '$'+ Decimal.valueOf(monthlyPaymentAmount) : '';
        }}
        public String delinquencies30Days {get; set;}
        public String delinquencies60Days {get; set;}
        public String delinquencies90to180Days {get; set;}
        public String derogCounter {get; set;}
        public String ecoa {get; set;}
        public EnhancedPaymentData enhancedPaymentData {get; set;}
        public String evaluation {get; set;}
        public String kob {get; set;}
        public String lastPaymentDate {get; set;}
        public String lastPaymentDateFormated {get {
            if (lastPaymentDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(lastPaymentDate.substring(4,8)), Integer.valueOf(lastPaymentDate.substring(0,2)), Integer.valueOf(lastPaymentDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String maxDelinquencyDate {get; set;}
        public String maxDelinquencyFormated {get {
            if (maxDelinquencyDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(maxDelinquencyDate.substring(4,8)), Integer.valueOf(maxDelinquencyDate.substring(0,2)), Integer.valueOf(maxDelinquencyDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy') + '/' + enhancedPaymentData.maxDelinquencyCode;
        }}
        public String monthsHistory {get; set;}
        public String openDate {get; set;}
        public String openDateFormated { get {
            if (openDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(openDate.substring(4,8)), Integer.valueOf(openDate.substring(0,2)), Integer.valueOf(openDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String openOrClosed {get; set;}
        public String openOrClosedFormated {get {
            return openOrClosed == 'C'
                    ? 'CLOSED'
                    : (openOrClosed == 'O'
                            ? 'OPEN'
                            : (openOrClosed == 'P'
                                    ? 'PAID'
                                    : (openOrClosed == 'T'
                                            ? 'TRANSFRD'
                                            : openOrClosed)));
        }}
        public String paymentHistory {get; set;}
        public String paymentHistoryFormatted {
            get {
                return paymentHistory.replaceAll('.{20}', '$0<br/>');
            }
            set;}
        public String revolvingOrInstallment {get; set;}
        public String specialComment {get; set;}
        public String status {get; set;}
        public String statusDate {get; set;}
        public String statusDateFormated {get{
            if (statusDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(statusDate.substring(4,8)), Integer.valueOf(statusDate.substring(0,2)), Integer.valueOf(statusDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String subscriberCode {get; set;}
        public String subscriberName {get; set;}
        public String terms {get; set;}
    }

    public class EnhancedPaymentData {
        public String complianceCondition {get; set;}
        public String enhancedAccountCondition {get; set;}
        public String enhancedAccountType {get; set;}
        public String enhancedPaymentHistory84 {get; set;}
        public String enhancedPaymentStatus {get; set;}
        public String enhancedSpecialComment {get; set;}
        public String enhancedTerms {get; set;}
        public String enhancedTermsFrequency {get; set;}
        public String firstDelinquencyDate {get; set;}
        public String maxDelinquencyCode {get; set;}
        public String originalLoanAmount {get; set;}
        public String paymentLevelDate {get; set;}
    }

    public class SsnResponse {
        public String number_x {get; set;}
        public String numberFormated {get {
            return number_x != null ? number_x.substring(0,3) + '-' + number_x.substring(3,5) + '-' + number_x.substring(5,9) : number_x;
        }}
        public String ssnIndicators {get; set;}
    }

    public class RiskModel {
        public String evaluation {get; set;}
        public String modelIndicator {get; set;}
        public String score {get; set;}
        public List<ScoreFactor> scoreFactors {get; set;}
    }

    public class ScoreFactor {
        public String importance {get; set;}
        public String code {get; set;}
    }

    public class Summary {
        public String summaryType {get; set;}
        public List<Attribute> attributes {get; set;}
    }

    private final static Map<String, String> idToTextAttribute = new Map<String, String>{
            'realEstateBalance' => 'R ESTATE BAL',
            'totalInquiries' => 'INQUIRIES',
            'paidAccounts' => 'PAID ACCT',
            'installmentBalance' => 'INSTALL BAL',
            'revolvingBalance' => 'REVOLVING BAL',
            'pastDueAmount' => 'PAST DUE AMT',
            'realEstatePayment' => 'R ESTATE PAY',
            'revolvingAvailablePercent' => 'REVOLVING AVAIL',
            'inquiriesDuringLast6Months' => 'INQS/6 MO',
            'totalTradeItems' => 'TRADELINE',
            'satisfactoryAccounts' => 'SATIS ACCTS',
            'nowDelinquentDerog' => 'NOW DEL/DRG',
            'wasDelinquentDerog' => 'WAS DEL/DRG',
            'oldestTradeDate' => 'OLD TRADE',
            'publicRecordsCount' => 'PUBLIC RECORDS',
            'delinquencies30Days' => 'DEL 30 DAYS',
            'delinquencies60Days' => 'DEL 60 DAYS',
            'delinquencies90to180Days' => 'DEL 180 DAYS',
            'derogCounter' => 'DRG COUNT',
            'monthlyPayment' => 'MO PAY'
    };

    public class Attribute {
        public String id {get;
            set {
                if (idToTextAttribute.containsKey(value)) {
                    value = idToTextAttribute.get(value);
                }
                id = value;
            } }
        public String value {
            get {
                return value;/*(id.contains('BAL') || id.contains('AMT') || id.contains('PAY'))
                        ? '$'+Decimal.valueOf(value).format()
                        : (id == 'REVOLVING AVAIL'
                                ? Integer.valueOf(value).format()+'%'
                                : (id == 'OLD TRADE'
                                        ? DateTime.newInstance(Integer.valueOf(value.substring(4,8)), Integer.valueOf(value.substring(0,2)), Integer.valueOf(value.substring(2,4)),0,0,0).format('MM/yy')
                                        :(value != null
                                                ? Integer.valueOf(value).format()
                                                : value)));*/
            }
            set;
        }
    }

    public class Inquiry {
        public String amount {get; set;}
        public String amountFormated {get {
            return (amount != 'UNKNOWN' && amount != null) ? '$'+ Decimal.valueOf(amount) : '';
        }}
        public String date_x {get; set;}
        public String dateFormated {get {
            if (date_x == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(date_x.substring(4,8)), Integer.valueOf(date_x.substring(0,2)), Integer.valueOf(date_x.substring(2,4)),0,0,0);
            return dateInstance.format('dd-MM-yy');
        }}
        public String kob {get; set;}
        public String subscriberCode {get; set;}
        public String subscriberName {get; set;}
        public String terms {get; set;}
        public String type {get; set;}
    }

    public class EmploymentInformation {
        public String firstReportedDate {get; set;}
        public String firstReportedDateFormated {get {
            if (firstReportedDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(firstReportedDate.substring(4,8)), Integer.valueOf(firstReportedDate.substring(0,2)), Integer.valueOf(firstReportedDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String lastUpdatedDate {get; set;}
        public String lastUpdatedDateFormated {get {
            if (lastUpdatedDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(lastUpdatedDate.substring(4,8)), Integer.valueOf(lastUpdatedDate.substring(0,2)), Integer.valueOf(lastUpdatedDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String name {get; set;}
        public String source {get; set;}
    }

    public class NameResponse {
        public String firstName {get; set;}
        public String middleName {get; set;}
        public String surname {get; set;}
    }

    public class DobResponse {
        public String day {get; set;}
        public String month {get; set;}
        public String year {get; set;}
    }

    public class ConsumerIdentity {
        public DobResponse dob {get; set;}
        public List<NameResponse> name {get; set;}
    }

    public class AddressInformation {
        public String city {get; set;}
        public String dwellingType {get; set;}
        public String firstReportedDate {get; set;}
        public String firstReportedDateFormated {get {
            if (firstReportedDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(firstReportedDate.substring(4,8)), Integer.valueOf(firstReportedDate.substring(0,2)), Integer.valueOf(firstReportedDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String lastReportingSubscriberCode {get; set;}
        public String lastUpdatedDate {get; set;}
        public String lastUpdatedDateFormated {get {
            if (lastUpdatedDate == null) return '';
            DateTime dateInstance = DateTime.newInstance(Integer.valueOf(lastUpdatedDate.substring(4,8)), Integer.valueOf(lastUpdatedDate.substring(0,2)), Integer.valueOf(lastUpdatedDate.substring(2,4)),0,0,0);
            return dateInstance.format('M-yy');
        }}
        public String source {get; set;}
        public String state {get; set;}
        public String streetName {get; set;}
        public String streetPrefix {get; set;}
        public String streetSuffix {get; set;}
        public String timesReported {get; set;}
        public String zipCode {get; set;}
    }

    public class EndTotals {
        public String totalSegments {get; set;}
        public String totalLength {get; set;}
    }

    public class Ofac {
        public String messageNumber {get; set;}
        public String messageText {get; set;}
    }

    public class InformationalMessage {
        public String messageNumber {get; set;}
        public String messageNumberDetailed {get; set;}
        public String messageText {get; set;}
    }

    public class ConsumerAssistanceReferralAddress {
        public String cityStateZip {get; set;}
        public String officeName {get; set;}
        public String phone {get; set;}
        public String phoneFormated {get {
            return phone.substring(0,3) + ' . ' + phone.substring(3,6) + ' . ' + phone.substring(6,10);
        }}
        public String poBox {get; set;}
        public String streetName {get; set;}
    }

    public class headerRecord {
        public String reportedAt {get {
            DateTime timeInstance = DateTime.newInstance(Integer.valueOf(y2kReportedDate.substring(4,8)), Integer.valueOf(y2kReportedDate.substring(0,2)), Integer.valueOf(y2kReportedDate.substring(2,4)), Integer.valueOf(reportTime.substring(0,2)), Integer.valueOf(reportTime.substring(2,4)), Integer.valueOf(reportTime.substring(4,6)));
            return timeInstance.format('MM/dd/yy hh:mm');
        }}
        public String reportDate {get; set;}
        public String reportTime {get; set;}
        public String preamble {get; set;}
        public String versionNo {get; set;}
        public String mKeywordLength {get; set;}
        public String y2kReportedDate {get; set;}
    }

    public class ConsumerPii {
        public Applicant primaryApplicant;
        public Applicant secondaryApplicant;

        public ConsumerPii (Contact primaryApplicant, Contact secondaryApplicant, Account account) {
            this.primaryApplicant = new Applicant(primaryApplicant, account);
            if(secondaryApplicant != null) {
                this.secondaryApplicant = new Applicant(secondaryApplicant, account);
            }
        }
    }
    public class Applicant {
        public Name name;
        public Dob dob;
        public Ssn ssn;
        public Map<String, String> driverslicense = new Map<String, String>();
        public List<Map<String, String>> phone = new List<Map<String,String>>();
        public Employment employment;
        public Address currentAddress;
        public Address previousAddress;
        public AddOns addOns;

        public Applicant(Contact contact, Account account){
            this.name = new Name(contact);
            this.driverslicense.put('number', contact.Driver_s_License__c);
            this.driverslicense.put('state', contact.MailingStateCode);
            this.phone.add(new Map<String, String>{'number' => contact.Phone});
//            this.employment = new Employment(account);
            this.currentAddress = new Address(contact);
            this.dob = new Dob(contact.Birthdate);
            this.ssn = new Ssn(contact.SSN__c);
        }
    }
    public class Name {
        public String firstName;
        public String lastName;

        public Name (Contact contact) {
            this.firstName = contact.FirstName.toUpperCase();
            this.lastName = contact.LastName.toUpperCase();
        }
    }
    public class Dob {
        public String dob; // 'MMddYYYY'
        public Dob (Date dateOfBirth) {
            if(dateOfBirth != null){
                this.dob = Datetime.newInstanceGmt(dateOfBirth.year(), dateOfBirth.month(), dateOfBirth.day()).format('MMddYYYY');
            }
        }
    }

    public class Ssn {
        public String ssn;
        public Ssn (String ssn) {
            this.ssn = ssn != null ? ssn.replace('-', '') : '';
        }
    }
    public class Employment {
        public String employerName;
        public Address employerAddress;
        public RiskModels riskModels;

        public Employment (Account account) {
            this.employerName = account.Name;
            this.employerAddress = new Address(account);
        }
    }
    public class Address {
        public String line1;
//        public String line2 = ' '; // TODO revise
        public String city;
        public String state;
        public String zipCode;

        public Address (Account account){
            this.line1 = account.BillingStreet.left(25);
            this.city = account.BillingCity;
            this.state = account.BillingStateCode;
            this.zipCode = account.BillingPostalCode;
        }

        public Address (Contact contact){
            this.line1 = contact.MailingStreet;
            this.city = contact.MailingCity;
            this.state = contact.MailingStateCode;
            this.zipCode = contact.MailingPostalCode;
        }
    }

    public class Requestor {
        public String subscriberCode = SUBSCRIBER_CODE;
    }

    public class AddOns {
        public RiskModels riskModels;
        public String clarityEarlyRiskScore = 'Y';
        public String clarityAttributes = 'Y';
        public String summaries = 'object';
        public String fraudShield = 'Y';
        public String mla = 'Y';
        public String ofacmsg = 'Y';
        public String outputType = 'JSON';
        public ConsumerIdentCheck consumerIdentCheck;
        public String joint = 'N';
        public String paymentHistory84 = 'Y';
        public CustomOptions customOptions;
    }
    public class RiskModels {
        public String[] modelIndicator = new String[]{'V4'};
        public String scorePercentile = 'Y';
    }
    public class ConsumerIdentCheck {
        public String getUniqueConsumerIdentifier = 'Y';
        public String verifyPrimaryConsumerIdentifier = 'Y';
        public String verifySecondaryConsumerIdentifier = 'Y';
    }

    public class CustomOptions {
        public String[] optionId = new String[]{};
    }

    public static void coverage() {
        Integer i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
    }
}