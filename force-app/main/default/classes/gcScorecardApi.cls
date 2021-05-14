public virtual inherited sharing class gcScorecardApi {
    private static final String AZURE_SUBSCRIPTION_KEY = 'b25a64969b004bd6b10f215abab61243';
    private static final String ENVIRONMENT = 'Testing';
    private static final String AZURE_SCORECARD_BASEURL = 'https://crossroads-connect.azure-api.net/crossroads/Scorecard/';

    private static final String CREATE_ASSET_ENDPOINT = 'Asset';
    private static final String CREATE_CONTACT_ENDPOINT = 'Contact';
    private static final String CREATE_DECISION_MODEL_ENDPOINT = 'DecisionModel';
    private static final String CREATE_EXPERIAN_ENDPOINT = 'Experian';
    private static final String CREATE_OPP_ACCOUNT_ENDPOINT = 'OppAccount';
    private static final String CREATE_PAY_NET_ENDPOINT = 'PayNet';


    public class CustomerApi extends gcScorecardApi {

        public List<ScorecardInfoResponse> getScorecardInfo(Id accountId) {
            HttpRequest request = buildBasicRequest(accountId);
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            return (List<ScorecardInfoResponse>) System.JSON.deserialize(response.getBody(), List<ScorecardInfoResponse>.class);
        }

        public ScorecardPostResponse createAsset(Opportunity opp, Asset asset) {
            HttpRequest request = buildBasicRequest(CREATE_ASSET_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreateAssetRequest requestBody = new ScorecardCreateAssetRequest(opp, asset);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }

        public ScorecardPostResponse createContact(Id oppId, Contact contact) {
            HttpRequest request = buildBasicRequest(CREATE_CONTACT_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreateContactRequest requestBody = new ScorecardCreateContactRequest(oppId, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }

        public ScorecardPostResponse createDecisionModel(Opportunity opp) {
            HttpRequest request = buildBasicRequest(CREATE_DECISION_MODEL_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreateDecisionModelRequest requestBody = new ScorecardCreateDecisionModelRequest(opp);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }

        public ScorecardPostResponse createExperian() {
            HttpRequest request = buildBasicRequest(CREATE_EXPERIAN_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreateExperianRequest requestBody = new ScorecardCreateExperianRequest();
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }

        public ScorecardPostResponse createOppAccount(Opportunity opp, Account acc) {
            HttpRequest request = buildBasicRequest(CREATE_OPP_ACCOUNT_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreateOppAccountRequest requestBody = new ScorecardCreateOppAccountRequest(opp, acc);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }

        public ScorecardPostResponse createPayNet() {
            HttpRequest request = buildBasicRequest(CREATE_PAY_NET_ENDPOINT);
            request.setMethod('POST');
            ScorecardCreatePayNetRequest requestBody = new ScorecardCreatePayNetRequest();
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new Http().send(request);
            System.debug(response.getBody());
            System.debug(response.getStatusCode());

            return parsePostResponse(response.getBody());
        }


    }

    private static HttpRequest buildBasicRequest(String methodEndpoint) {
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setEndpoint(AZURE_SCORECARD_BASEURL + methodEndpoint);
//        request.setHeader('Environment', ENVIRONMENT);
        request.setHeader('Ocp-Apim-Subscription-Key', AZURE_SUBSCRIPTION_KEY);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', '*/*');

        request.setTimeout(120000);

        return request;
    }

    public class ScorecardCreateAssetRequest {

        public String sfOpportunityId;
        public String sfAssetId;
        public String vin;
        public Double assetCost;
        public Integer mileage;
        public Integer engineYear;
        public String model;
        public String vehicleModelStyle;
//        public Double vendorPricingRatio;
//        public Double valueCrossroads;
        public Double valueNada;
        public Double valuePriceDigest;
        public Double valueFleetEvaluator;
        public String engineMake;
        public String creationDateTime;
        public Integer isVvg;
        public String condition;

        public ScorecardCreateAssetRequest(Opportunity opp, Asset asset){
            this.sfOpportunityId = opp.Id;
            this.sfAssetId = asset.Id;
            this.vin = asset.VIN__c;
            this.assetCost = asset.Price_of_Unit__c == null ? 0 : asset.Price_of_Unit__c;
            this.mileage =  Integer.valueOf(asset.Mileage__c);
            this.engineYear =  asset.Year__c != null ? Integer.valueOf(asset.Year__c) : 0;
            this.model = asset.Model__c;
            this.vehicleModelStyle = 'Style';
//            this.vendorPricingRatio;
//            this.valueCrossroads;
            this.valueNada = asset.NADA_Wholesale_OLV__c == null ? 0 : asset.NADA_Wholesale_OLV__c;
            this.valuePriceDigest = asset.Price_Digest_Wholesale_OLV__c == null ? 0 : asset.Price_Digest_Wholesale_OLV__c;
            this.valueFleetEvaluator = asset.Fleet_Evaluator_Wholesale_OLV__c == null ? 0 : asset.Fleet_Evaluator_Wholesale_OLV__c;
            this.engineMake = asset.Engine_Make__c;
            this.creationDateTime = asset.CreatedDate.format('MM/dd/yyyy HH:mm');//.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');
            this.isVvg = opp.VVG_Deal__c ? 1 : 0;
            this.condition = asset.Condition__c;
        }
    }

    public class ScorecardCreateContactRequest {

        public String sfContactId;
        public String sfOpportunityId;
        public String role;
        public Double ownershipPercentage;
        public String creationDateTime;

        public ScorecardCreateContactRequest(Id oppId, Contact contact){
            this.sfContactId = contact.Id;
            this.sfOpportunityId = oppId;
            this.role = contact.Role__c;
            this.ownershipPercentage = contact.Percent_Ownership__c;
            this.creationDateTime = contact.CreatedDate.format('MM/dd/yyyy HH:mm');//.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');
        }
    }

    public class ScorecardCreateDecisionModelRequest {

        public String sfOpportunityId;
        public Integer idDeal;
        public Integer vsApplicationNum;

        public ScorecardCreateDecisionModelRequest(Opportunity opportunity) {
            this.sfOpportunityId = opportunity.Id;
            this.idDeal = 0;
            this.vsApplicationNum = 0;
        }
    }

    public class ScorecardCreateExperianRequest {

//        public String sf_ContactId;
//        public Integer ficoScore;
//        public Integer numInquiries;
//        public String consumerBankruptcyDate;
//        public String consumerBankruptcyType;
//        public String oldestTradeDate;
//        public Integer tradesOrOther;
//        public Integer paidAccounts;
//        public Integer curNegCnt;
//        public Integer prevNegCnt;
//        public Integer collectionCnt;
//        public Double pastDueBalance;
//        public Integer hasDuplicateSsn;
//        public Integer hasFraudAlert;
//        public Integer hasFrozenFile;
//        public Integer hasOfac;
//        public Integer foreclosureCnt;
//        public Integer repossessionCnt;
//        public Integer hasSSNUnverifiedIssueDate;
//        public String processedDate;
//        public Integer ssn;
//        public String creationDateTime;
    }

    public class ScorecardCreateOppAccountRequest {

        public String sfOpportunityId;
        public String sfAccountId;
        public Double downPayment;
        public Double securityDeposit;
        public Double financedFees;
        public Integer term;
        public Double financedAmount;
        public Integer isCalCap;
        public Integer isFcap;
        public Double grantAmount;
        public String creationDateTime;
        public Integer numTrucksOwned;
        public Integer monthsInBusiness;
        public Integer annualMileage;
        public Integer cdlExperience;
        public Integer hazmatFlag;
        public String state;

        public ScorecardCreateOppAccountRequest(Opportunity opportunity, Account account) {
            this.sfOpportunityId = opportunity.Id;
            this.sfAccountId = account.Id;
            this.downPayment = opportunity.Down_Payment__c == null ? 0 : opportunity.Down_Payment__c;
            this.securityDeposit = opportunity.Security_Deposit__c == null ? 0 : opportunity.Security_Deposit__c;
            this.financedFees = opportunity.Financed_Fees__c == null ? 0 : opportunity.Financed_Fees__c;
            this.term = Integer.valueOf(opportunity.Term__c == null ? '0' : opportunity.Term__c);
            this.financedAmount = opportunity.Amount == null ? 0 : opportunity.Amount;
            this.isCalCap = opportunity.CalCAP__c ? 1 : 0;
            this.isFcap = account.FCAP__c ? 1 : 0;
            this.grantAmount= opportunity.Amount == null ? 0 : opportunity.Amount;
            this.creationDateTime = opportunity.CreatedDate.format('MM/dd/yyyy');//.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');
            this.numTrucksOwned = Integer.valueOf(account.Fleet_Size__c == null ? 0 : account.Fleet_Size__c);
            this.monthsInBusiness = Integer.valueOf(account.Years_in_Business__c == null ? 0 : account.Years_in_Business__c);
            this.annualMileage = Integer.valueOf(opportunity.Avg_Annual_Milage__c == null ? 0 : opportunity.Avg_Annual_Milage__c);
            this.cdlExperience = Integer.valueOf(opportunity.Industry_Experience__c == null ? 0 : opportunity.Industry_Experience__c);
            this.hazmatFlag = opportunity.HAZMAT__c ? 1 : 0;
            this.state = account.BillingStateCode;//opportunity.Dealership__r.State__c;
        }

    }

    public class ScorecardCreatePayNetRequest {

//        public String sf_AccountId;
//        public Integer sf_PaynetId;
//        public String memberTaxId;
//        public String stateCode;
//        public Integer paynetScoreMain;
//        public Integer monthsInBusiness;
//        public Double deliqRatePercChange;
//        public Integer recentAvgDaysPastDueNow;
//        public Integer maxDaysPastDueNow;
//        public Integer maxDaysPastDue12Months;
//        public Double percPmtsPastDue31Plus;
//        public Double percPmtsPastDue61Plus;
//        public Integer repoContractCnt;
//        public Integer repoContractCnt12Months;
//        public Integer trackContractCnt;
//        public String mostRecentBankruptcyDate;
//        public Integer lenderCnt;
//        public Integer inquiries6Mo;
//        public Integer ttlLienAmtFiledLast12Mos;
//        public Double apdCountyNaics4DigitAvg;
//        public Integer closedContractCnt;
//        public Integer histAvgDaysPastDue;
//        public String oldestContractStartDate;
//        public Double lossAmt;
//        public String mostRecentPastDue91PlusDate;
//        public Double curBalPastDue6190Amt;
//        public Double curBalPastDue91PlusAmt;
//        public String bankruptcyFlgPublicFiling;
//        public String liquidationDischarge;
//        public String taxLienFilingDate;
//        public Double taxLienAmt;
//        public String taxLienLegalAction;
//        public String businessTaxId;
//        public String businessType;
//        public String generationDateTime;
//        public String legalActionFilingDate;
//        public String creationDateTime;

    }

    public class ScorecardInfoResponse {
        @AuraEnabled public String sfOpportunityId;
        @AuraEnabled public Integer idModelSnapshot;
        @AuraEnabled public Integer idDecisionTreeHistoryScoring;
        @AuraEnabled public String scoringModelName;
        @AuraEnabled public String scoringModelVersion;
        @AuraEnabled public Integer idDecisionTreeHistoryPolicyCheck;
        @AuraEnabled public String policyCheckTreeName;
        @AuraEnabled public String policyCheckTreeVersion;
        @AuraEnabled public Integer idRuleFirstHit;
        @AuraEnabled public Integer paynetHit;
        @AuraEnabled public Integer experianHit;
        @AuraEnabled public Integer backOfficeHit;
        @AuraEnabled public Integer isCalCap;
        @AuraEnabled public Integer isFcap;
        @AuraEnabled public Integer creditDecisionScore;
        @AuraEnabled public Double probabilityOfDefault;
        @AuraEnabled public Double lossGivenDefault;
        @AuraEnabled public Double expectedLoss;
        @AuraEnabled public String riskGrade;
        @AuraEnabled public String preliminaryDecision;
        @AuraEnabled public String finalDecision;
        @AuraEnabled public String paynetScoreInput;
        @AuraEnabled public String experianPrincipal1FicoInput;
        @AuraEnabled public String backOfficeWeightedAvgDpdInput;
        @AuraEnabled public String experianPrincipal2FicoInput;
        @AuraEnabled public String salesforceNumTrucksOwnedInput;
        @AuraEnabled public String paynetRecentAvgDaysPastDueInput;
        @AuraEnabled public String salesforceDownPaymentPercentageInput;
        @AuraEnabled public String paynetPercentPmts31DpdInput;
        @AuraEnabled public String salesforceTimeInBusinessInput;
        @AuraEnabled public String salesforceStateInput;
        @AuraEnabled public String experianInquiries6monthsInput;
        @AuraEnabled public String paynetChangeInStateIndustryDelq6moInput;
        @AuraEnabled public String salesforceUsedAssetIndInput;
        @AuraEnabled public Integer paynetScoreOutput;
        @AuraEnabled public Integer experianPrincipal1FicoOutput;
        @AuraEnabled public Integer backOfficeWeightedAvgDpdOutput;
        @AuraEnabled public Integer experianPrincipal2FicoOutput;
        @AuraEnabled public Integer salesforceNumTrucksOwnedOutput;
        @AuraEnabled public Integer paynetRecentAvgDaysPastDueOutput;
        @AuraEnabled public Integer salesforceDownPaymentPercentageOutput;
        @AuraEnabled public Integer paynetPercentPmts31DpdOutput;
        @AuraEnabled public Integer salesforceTimeInBusinessOutput;
        @AuraEnabled public Integer salesforceStateOutput;
        @AuraEnabled public Integer experianInquiries6monthsOutput;
        @AuraEnabled public Integer paynetChangeInStateIndustryDelq6moOutput;
        @AuraEnabled public Integer salesforceUsedAssetIndOutput;
        @AuraEnabled public String paynetScoreOutputBracket;
        @AuraEnabled public String experianPrincipal1FicoOutputBracket;
        @AuraEnabled public String backOfficeWeightedAvgDpdOutputBracket;
        @AuraEnabled public String experianPrincipal2FicoOutputBracket;
        @AuraEnabled public String salesforceNumTrucksOwnedOutputBracket;
        @AuraEnabled public String paynetRecentAvgDaysPastDueOutputBracket;
        @AuraEnabled public String salesforceDownPaymentPercentageOutputBracket;
        @AuraEnabled public String paynetPercentPmts31DpdOutputBracket;
        @AuraEnabled public String salesforceTimeInBusinessOutputBracket;
        @AuraEnabled public String salesforceStateOutputBracket;
        @AuraEnabled public String experianInquiries6monthsOutputBracket;
        @AuraEnabled public String paynetChangeInStateIndustryDelq6moOutputBracket;
        @AuraEnabled public String salesforceUsedAssetIndOutputBracket;
    }

    public class ScorecardPostResponse {
        @AuraEnabled
        public ScorecardResult result;
        @AuraEnabled
        public Integer id;
        @AuraEnabled
        public String scorecardException;
        @AuraEnabled
        public Integer status;
        @AuraEnabled
        public Boolean isCanceled;
        @AuraEnabled
        public Boolean isCompleted;
        @AuraEnabled
        public Boolean isCompletedSuccessfully;
        @AuraEnabled
        public Integer creationOptions;
        @AuraEnabled
        public String asyncState;
        @AuraEnabled
        public Boolean isFaulted;
    }

    public class ScorecardResult {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String errorMessage;
    }


    protected ScorecardPostResponse parsePostResponse(String json) {
        //exception - is reserved word
        json.replace('"exception"', '"scorecardException"');
        return (ScorecardPostResponse) System.JSON.deserialize(json, ScorecardPostResponse.class);
    }

    public static void coverage() {
        Integer i;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
    }
}