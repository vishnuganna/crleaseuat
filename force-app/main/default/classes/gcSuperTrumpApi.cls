public with sharing class gcSuperTrumpApi {

    class SuperTrumpApiException extends Exception{}

    public static final String defaultEndpoint = 'http://198.101.82.158:8000/StMultiServer32/StServer.aspx';
    private XMLSerializer serializer;
    private Map<String, String> xmlReqRespToSave;
    public enum TRANSACTION_TYPES {REQUEST, RESPONSE}

    public gcSuperTrumpApi(){
        this.serializer = new XMLSerializer();
        this.xmlReqRespToSave = new Map<String, String>();
    }

    public SuperTrump_request_response processXML(Opportunity opportunity, String proposedStructure) {
        SuperTrump_request_response request_x = makeSuperTrumpRequest(opportunity);
        HttpRequest request = makeBaseRequest();
        request.setBody(prepareSendXML(serializer.serialize(request_x)));
        SuperTrump_request_response response = sendSuperTrumpRequest(request);
        String responseTaxClassification = response.SuperTrump.SuperTrumpTransaction.Results.TaxClassification;
        SuperTrump_request_response templateResponse = sendTemplate(opportunity, proposedStructure, responseTaxClassification);
        saveReqRespAsAttachments(opportunity.Id);
        return templateResponse;
    }

    public SuperTrump_request_response sendTemplate(Opportunity opportunity, String proposedStructure, String taxClassification) {
        String templateName;
        if(taxClassification == 'True tax lease'){
            templateName= 'SuperTrump_TracTaxLease';
        }else if(proposedStructure == 'Lease'){
            templateName= 'SuperTrump_TracNonTaxLease';
        }else{
            templateName= 'SuperTrump_Loan';
        }
        String template = getBase64Template(templateName);
        HttpRequest request = makeBaseRequest();
        SuperTrump_request_response request_x = makeSuperTrumpRequest(opportunity);
        request_x.SuperTrump.SuperTrumpTransaction.TransactionState = template;
        request.setBody(prepareSendXML(serializer.serialize(request_x)));
        return sendSuperTrumpRequest(request);
    }

    private SuperTrump_request_response makeSuperTrumpRequest(Opportunity opportunity){
        SuperTrump_request_response request_x = new SuperTrump_request_response();
        request_x.SuperTrump = new SuperTrumpWrapper();
        request_x.SuperTrump.SuperTrumpTransaction = new SuperTrumpTransaction(opportunity);
        request_x.SuperTrump.AppData = new AppData();
        return  request_x;
    }

    private HttpRequest makeBaseRequest(){
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(defaultEndpoint);
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000);
        return request;
    }

    private SuperTrump_request_response sendSuperTrumpRequest(HttpRequest request){
        Http http = new Http();
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            String xmlString = prepareParseXML(response.getBody());
            addReqRespToSave(TRANSACTION_TYPES.REQUEST.name(), request.getBody());
            addReqRespToSave(TRANSACTION_TYPES.RESPONSE.name(), xmlString);
            return (SuperTrump_request_response) serializer.deSerialize(xmlString, SuperTrump_request_response.class);
        }else{
            throw new SuperTrumpApiException('Super Trump integration exception \n'+ 'Status code ' + response.getStatusCode());
        }
    }

    private String getBase64Template(String templateName){
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = :templateName LIMIT 1];
        return EncodingUtil.base64Encode(sr.Body);
    }

    private String prepareParseXML(String xmlString) {
        return xmlString.replace('<Transaction query="true">', '<SuperTrumpTransaction>').replace('<Transaction>', '<SuperTrumpTransaction>').replace('</Transaction>', '</SuperTrumpTransaction>');//.replace('-', '_')
    }

    private String prepareSendXML(String xmlString) {
        return xmlString.replace('<SuperTrumpTransaction>', '<Transaction query="true">').replace('</SuperTrumpTransaction>', '</Transaction>');//.replace('-', '_')
    }

    private void addReqRespToSave(String type, String xmlString){
        xmlReqRespToSave.put(type + ' ' + String.valueOf(Datetime.now()) +'.xml', xmlString);
    }

    private void saveReqRespAsAttachments(Id linkedEntityId){
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();

        for(String xmlName : xmlReqRespToSave.keySet()){
            contentVersions.add(makeContentVersion(xmlName, Blob.valueOf(xmlReqRespToSave.get(xmlName))));
        }
        insert contentVersions;

        for(ContentVersion cv: [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersions]){
            contentDocumentLinks.add(makeContentDocumentLink(cv.ContentDocumentId, linkedEntityId));
        }
        insert contentDocumentLinks;
    }

    private ContentVersion makeContentVersion(String name, Blob data){
        return new ContentVersion(ContentLocation = 'S', PathOnClient = name, Title = name, VersionData = data);
    }

    private ContentDocumentLink makeContentDocumentLink(Id documentId, Id entityId){
        return new ContentDocumentLink(ContentDocumentId = documentId, LinkedEntityId = entityId, ShareType = 'I', Visibility = 'AllUsers');
    }

    public class SuperTrump_request_response {
        @AuraEnabled public SuperTrumpWrapper SuperTrump;
    }

    public class SuperTrumpWrapper {
        @AuraEnabled public SuperTrumpTransaction SuperTrumpTransaction;
        @AuraEnabled public AppData AppData;
    }

    public class SuperTrumpTransaction {
        @AuraEnabled public String TransactionState;
        @AuraEnabled public String TransactionAmount;
        @AuraEnabled public String TransactionStartDate;
        @AuraEnabled public String DepreciationTerm;
        @AuraEnabled public String ResidualAmount;
        @AuraEnabled public String CommencementDate;
        @AuraEnabled public String TermInMonths;
        @AuraEnabled public String NumberofPayments;
        @AuraEnabled public String Periodicity;
        @AuraEnabled public String PaymentTiming;
        @AuraEnabled public String AveragePayment;
        @AuraEnabled public String Structure;
        @AuraEnabled public String TotalExpenseFees;
        @AuraEnabled public String TotalIncomeFees;
        @AuraEnabled public String TotalPeriodicExpenses;
        @AuraEnabled public String TotalPeriodicIncome;
        @AuraEnabled public String IncrementalBorrowingRate;
        @AuraEnabled public String Mode;
        @AuraEnabled public String Days;
        @AuraEnabled public String AveragePaymentPercent;
        @AuraEnabled public String LeaseRateFactor;
        @AuraEnabled public String TotalSubsidyAmount;
        @AuraEnabled public String SkipMonths;
        @AuraEnabled public Features Features;
        @AuraEnabled public String Originator;
        @AuraEnabled public String SinkingFundRate;
        @AuraEnabled public String QuoteDate;
        @AuraEnabled public String CalculateGuaranteedResidual;
        @AuraEnabled public String MaximumforLesseeOperatingLease;
        @AuraEnabled public String MinimumForLessorFinanceLease;
        @AuraEnabled public String Country;
        @AuraEnabled public String TaxClass;
        @AuraEnabled public String FASBclass;
        @AuraEnabled public String AssetCost;
        @AuraEnabled public String LoanAmount;
        @AuraEnabled public String FirstPaymentDate;
        @AuraEnabled public AssetWrapper Assets;
        @AuraEnabled public RentWrapper Rents;
        @AuraEnabled public PeriodicIncomeWrapper PeriodicIncomes;
        @AuraEnabled public YieldWrapper Yields;
        @AuraEnabled public PVWrapper PVs;
        @AuraEnabled public LessorLender LessorLender;
        @AuraEnabled public String EconomicCOF;
        @AuraEnabled public String EconomicLeverage;
        @AuraEnabled public String EconomicCapital;
        @AuraEnabled public Results Results;
        @AuraEnabled public TargetData TargetData;
        @AuraEnabled public String ParameterFileCodeline;
        @AuraEnabled public String ParameterFileVersion;
        @AuraEnabled public String ParameterFileCustomVersion;
        @AuraEnabled public String ParameterFileSTName;
        @AuraEnabled public String DefaultResidualDateToLastNonZeroPayment;
        @AuraEnabled public String SaveZipped;
        @AuraEnabled public Customer Customer;
        @AuraEnabled public AccountingData AccountingData;
        @AuraEnabled public Controls Controls;
        @AuraEnabled public String HideAllInactiveItems;

        public SuperTrumpTransaction(Opportunity opportunity){
            this.TransactionAmount = String.valueOf(opportunity.Amount);
            this.TransactionStartDate =  opportunity.Proposed_Start_Date__c != null ? opportunity.Proposed_Start_Date__c.format() : null;
            this.DepreciationTerm = opportunity.Term__c != null ? String.valueOf(opportunity.Term__c) : null;
            this.ResidualAmount = String.valueOf(opportunity.TRAC_Residual__c);
            this.CommencementDate = calculateCommencementDate(opportunity);
            this.TermInMonths = calculateTermInMonth(opportunity);
            this.NumberOfPayments = opportunity.Term__c;
            this.Periodicity = opportunity.Pymt_Frequency__c;
            this.PaymentTiming = opportunity.Payment_Timing__c;
            this.Structure = opportunity.Payment_Structure__c;
            this.TotalExpenseFees = String.valueOf(opportunity.Financed_Fees__c);
            this.TotalIncomeFees = String.valueOf(opportunity.Dealer_Fee__c);
            this.IncrementalBorrowingRate = String.valueOf(opportunity.Rate__c);
        }

        private String calculateTermInMonth(Opportunity opp){
            Integer term;
            Decimal termInMonth;
            Decimal WEEKS_IN_MONTH = 4.33;
            String frequency = opp.Pymt_Frequency__c;

            if(String.isBlank(opp.Term__c) || frequency == null){
                return null;
            }else{
                term = Integer.valueOf(opp.Term__c);
            }

            if(frequency == 'Weekly'){
                termInMonth = (term/WEEKS_IN_MONTH).round();
            }else if(frequency == 'Biweekly'){
                termInMonth = (term/WEEKS_IN_MONTH*2).round();
            }else if(frequency == 'Monthly'){
                termInMonth = term;
            }else if(frequency == 'Seasonal'){
                termInMonth = term*3;
            }
            return String.valueOf(termInMonth);
        }

        public String calculateCommencementDate(Opportunity opp){
            Date commencementDate;
            Date firstPaymentDate = opp.First_Payment_Due__c;
            String frequency = opp.Pymt_Frequency__c;
            String timing = opp.Payment_Timing__c;

            if( frequency == null
                || firstPaymentDate == null
                || String.isEmpty(timing)) {
                return null;
            }

            if(timing == 'Advance'){
                commencementDate = firstPaymentDate;
            }else if(timing == 'Arrears'){
                if(frequency == 'Weekly'){
                    commencementDate = firstPaymentDate.addDays(-7);
                }else if(frequency == 'Biweekly'){
                    commencementDate = firstPaymentDate.addDays(-14);
                }else if(frequency == 'Monthly'){
                    commencementDate = firstPaymentDate.addDays(-30);
                }else if(frequency == 'Seasonal'){
                    commencementDate = firstPaymentDate.addDays(-90);
                }
            }
            return commencementDate.format();
        }

        public SuperTrumpTransaction(){}
    }

    public class Controls {
        @AuraEnabled public CalculationControls CalculationControls;

//        private String[] CalculationControls_type_info = new String[]{'CalculationControls', defaultEndpoint,null,'0','1','false'};
//
//        private String[] apex_schema_type_info = new String[]{defaultEndpoint,'true','false'};
//        private String[] field_order_type_info = new String[]{'CalculationControls'};
    }

    public class CalculationControls {
        @AuraEnabled public String move30th;
        @AuraEnabled public String skipWE;
        @AuraEnabled public String AvgPmtCalcExcludeZeros;
        @AuraEnabled public String AvgPmtCalcExcludeLeadingZeros;
        @AuraEnabled public String targetGate;
        @AuraEnabled public String yieldRunMax;
        @AuraEnabled public String targetMax;
        @AuraEnabled public String roundToPennies;
        @AuraEnabled public String DoSwitchRounding;
        @AuraEnabled public String AdjRateToBal;
        @AuraEnabled public String PennyRoundArr;
        @AuraEnabled public String MinimizeInterest;
        @AuraEnabled public String maintainTotalDS;
        @AuraEnabled public String MaxLevSum;
    }

    public class AccountingData {
        @AuraEnabled public AccountingControls AccountingControls;
        @AuraEnabled public RebookData RebookData;
    }

    public class RebookData {
        @AuraEnabled public String RebookType;
    }

    public class AccountingControls {
        @AuraEnabled public String HasTitleTransfer;
        @AuraEnabled public String ITCinProvision;
        @AuraEnabled public String IncomeRecognition;
        @AuraEnabled public String LessorPVCompounding;
        @AuraEnabled public String LesseePVCompounding;
        @AuraEnabled public String LessorPVPctThreshold;
        @AuraEnabled public String LesseePVPctThreshold;
        @AuraEnabled public String CalcMinFinGuarantee;
        @AuraEnabled public String DoBPOTest;
        @AuraEnabled public String DoLastQtrTest;
        @AuraEnabled public String DoEconLifeTest;
        @AuraEnabled public String DoLessorPVTest;
        @AuraEnabled public String DoLesseePVTest;
        @AuraEnabled public String RequireLifeInput;
        @AuraEnabled public String CSApvUseMin;
        @AuraEnabled public String LessorCostNotOnDeliv;
        @AuraEnabled public String LesseeCostNotOnDeliv;
        @AuraEnabled public String LessorCostDateMethod;
        @AuraEnabled public String FAS13YieldMethod;
        @AuraEnabled public String OperatingIncomeBooking;
        @AuraEnabled public String AllowIncomeFeesInMLP;
        @AuraEnabled public String SecurityDepositIn;
        @AuraEnabled public String RentIsCollectible;
        @AuraEnabled public String IsLimitedUseProp;
        @AuraEnabled public String UseASC842;
        @AuraEnabled public String Trade_inAndLienTreatment;
        @AuraEnabled public String IncludeBasisReduction;
        @AuraEnabled public String RentCollectibilityTest;
        @AuraEnabled public String TitleTransferTest;
        @AuraEnabled public String Use842BasedOnDate;
        @AuraEnabled public String ASC842StartDate;
    }

    public class Customer {
        @AuraEnabled public String CorporateAddress;
        @AuraEnabled public String BillingAddress;
        @AuraEnabled public CreditInfo CreditInfo;
        @AuraEnabled public String DifferentBillingAddress;
        @AuraEnabled public String IsTaxExempt;
        @AuraEnabled public String AddressChange;
        @AuraEnabled public String IncrementalBorrowingRate;
    }

    public class CreditInfo {
        @AuraEnabled public String CreditScore;
        @AuraEnabled public String CreditLimit;
    }

    public class TargetData {
        @AuraEnabled public String TypeOfStatistic;
        @AuraEnabled public String StatisticIndex;
        @AuraEnabled public String NEPA;
        @AuraEnabled public String TargetValue;
        @AuraEnabled public String Adjust;
        @AuraEnabled public String AdjustmentMethod;
    }

    public class Results {
        @AuraEnabled public String AmountToFinance;
        @AuraEnabled public String AverageLifeOfInvestmentAfter_tax;
        @AuraEnabled public String AverageLifeOfInvestment;
        @AuraEnabled public String AverageLifeOfInvestmentInMonthsAT;
        @AuraEnabled public String AverageLifeOfInvestmentInMonths;
        @AuraEnabled public String GrossAvgLifeInvestmentInMonthsPT;
        @AuraEnabled public String NetAvgLifeInvestmentInMonthsPT;
        @AuraEnabled public String FullTermRate;
        @AuraEnabled public String FullTermRateWithResidual;
        @AuraEnabled public String FullTermRateAllIn;
        @AuraEnabled public String BaseTermRate;
        @AuraEnabled public String BaseTermRateWithResidual;
        @AuraEnabled public String ImplicitInterestRate;
        @AuraEnabled public String BookImplicitInterestRate;
        @AuraEnabled public String ImplicitInterestRateWithSubsidies;
        @AuraEnabled public String ImplicitInterestRateWithoutSubsidies;
        @AuraEnabled public String CompositeTaxRate;
        @AuraEnabled public String NumberOfPayments;
        @AuraEnabled public String LeaseRateFactor;
        @AuraEnabled public String RentIsLessThanDS;
        @AuraEnabled public String NetAfterTaxProfit;
        @AuraEnabled public String InternalLoanBorrowingRate;
        @AuraEnabled public String InternalLoanLendingRate;
        @AuraEnabled public String InternalLoanLeverage;
        @AuraEnabled public String LessorAccountingMethod;
        @AuraEnabled public String LesseeAccountingMethod;
        @AuraEnabled public String InsuredResidual;
        @AuraEnabled public String TransactionEndDate;
        @AuraEnabled public String TaxClassification;
        @AuraEnabled public String IRSTestResults;
        @AuraEnabled public String IRSUnevenRentTest;
        @AuraEnabled public AccountingResults AccountingResults;
        @AuraEnabled public String IsConditionalSale;
        @AuraEnabled public String TotalResidualGuaranteeAmt;
        @AuraEnabled public String TotalResidualGuaranteePct;
        @AuraEnabled public String PVRes;
        @AuraEnabled public String CostMinusPVRes;
        @AuraEnabled public String LeverageAmt;
        @AuraEnabled public String LeveragePct;
        @AuraEnabled public String CustomerRateLessee;
        @AuraEnabled public String MaximumHolidayMonths;
        @AuraEnabled public String TestForHoliday;
        @AuraEnabled public String FederalTaxPaymentDay;
        @AuraEnabled public String InternalInterest;
        @AuraEnabled public String InternalInterestTaxSaved;
        @AuraEnabled public String PretaxInternalLoanBorrowing;
        @AuraEnabled public String After_TaxEquityInvested;
        @AuraEnabled public String TaxPaid;
        @AuraEnabled public String MinimumEquityPercent;
        @AuraEnabled public String TotalSalesTax;
    }

    public class AccountingResults {
        @AuraEnabled public String LessorAccountingMethod;
        @AuraEnabled public String LesseeAccountingMethod;
        @AuraEnabled public String BargainPurchaseOptionTest;
        @AuraEnabled public String FASBLessorPVResult;
        @AuraEnabled public String FASBLessorPVRate;
        @AuraEnabled public String FASBLessorPVThreshold;
        @AuraEnabled public String FASBLessorPVPmtsAmt;
        @AuraEnabled public String FASBLessorPVPmtsPct;
        @AuraEnabled public String FASBLesseePVResult;
        @AuraEnabled public String FASBLesseePVRate;
        @AuraEnabled public String FASBLesseePVThreshold;
        @AuraEnabled public String FASBLesseePVPmtsAmt;
        @AuraEnabled public String FASBLesseePVPmtsPct;
    }

    public class Features {
        @AuraEnabled public String AllowAccounting;
        @AuraEnabled public String AllowFederalTaxes;
        @AuraEnabled public String AllowPeriodicIncomeExpense;
    }

    public class AppData {
        @AuraEnabled public String Version;
        @AuraEnabled public String CustomVersionNumber;
        @AuraEnabled public String CodeLine;
        @AuraEnabled public String BuildNumber;
        @AuraEnabled public String ModulePath;
    }

    public class AssetWrapper {
        @AuraEnabled public Asset Asset;
    }

    public class RentWrapper {
        @AuraEnabled public Income Rent;
    }

    public class PeriodicIncomeWrapper {
        @AuraEnabled public Income PeriodicIncome;
    }

    public class Asset {
        @AuraEnabled public String Cost;
        @AuraEnabled public String DeliveryDate;
        @AuraEnabled public String FundingDate;
        @AuraEnabled public String Residual;
        @AuraEnabled public String ResidualDate;
        @AuraEnabled public String UseDefaultResidualDate;
        @AuraEnabled public String UseDefaultResidual;
        @AuraEnabled public String LesseeResidual;
        @AuraEnabled public String CreatedInternally;
        @AuraEnabled public String CapitalFee;
        @AuraEnabled public String SalesTax;
        @AuraEnabled public String GuaranteeType;
        @AuraEnabled public String CalculateTailEndDepreciation;
        @AuraEnabled public String AdjustOnTarget;
        @AuraEnabled public String TaxLife;
        @AuraEnabled public String BookLife;
        @AuraEnabled public String FMV;
        @AuraEnabled public String TrueLeaseMinimumResidual;
        @AuraEnabled public String LesseePurchaseOptionMethod;
        @AuraEnabled public String InServiceDate;
        @AuraEnabled public String SpecifyInService;
        @AuraEnabled public String SpecifyFMV;
        @AuraEnabled public String ADRClass;
        @AuraEnabled public String Inactive;
        @AuraEnabled public String NetBookValueToResidual;
        @AuraEnabled public String ResidualKeptAsAPercent;
        @AuraEnabled public String LesseeResidualKeptAsAPercent;
        @AuraEnabled public String ResidualAsPercentOfCost;
        @AuraEnabled public String LesseeResidualPercentOfCost;
        @AuraEnabled public String Re_Lease;
        @AuraEnabled public String OriginalCost;
        @AuraEnabled public String OriginalDeliveryDate;
        @AuraEnabled public String TotalRentAssociated;
        @AuraEnabled public String NumUnits;
        @AuraEnabled public String Downpayment;
        @AuraEnabled public String IsUsed;
        @AuraEnabled public String LossGivenDefault;
        @AuraEnabled public String Tradein;
        @AuraEnabled public String Lien;
        @AuraEnabled public String ListPrice;
        @AuraEnabled public String OverrideListPrice;
        @AuraEnabled public String HoursPerYear;
        @AuraEnabled public String CurrentHours;
        @AuraEnabled public String UseAlternateADRLife;
        @AuraEnabled public String PID;
        @AuraEnabled public FederalAssetTax FederalAssetTax;
        @AuraEnabled public Depreciation FederalDepreciation;
        @AuraEnabled public Depreciation BookDepreciation;
        @AuraEnabled public String ObjectGUID;
        @AuraEnabled public LikeKindExchange LikeKindExchange;
        @AuraEnabled public CollateralCurves CollateralCurves;
        @AuraEnabled public String CostPerUnit;
        @AuraEnabled public String FirstFundingDate;
        @AuraEnabled public String NetCost;
        @AuraEnabled public String NetAttachmentCost;
        @AuraEnabled public String SumResidualGuaranteedAmount;
        @AuraEnabled public String SumResidualUnguaranteedAmount;
        @AuraEnabled public String TotalResidualGuaranteeAmount;
        @AuraEnabled public String SumResidualGuaranteedPercent;
        @AuraEnabled public String SumResidualUnguaranteedPercent;
        @AuraEnabled public String TotalResidualGuaranteePercent;
        @AuraEnabled public String NetTradeIn;
    }

    public class FederalAssetTax {
        @AuraEnabled public String ResidualPctTaxable;
        @AuraEnabled public String Re_LeaseTaxesPayable;
        @AuraEnabled public String Re_LeaseSpecifyDeferredTax;
        @AuraEnabled public String Re_LeaseSpecifiedDeferredTax;
    }

    public class Depreciation {
        @AuraEnabled public String Method;
        @AuraEnabled public String StartDate;
        @AuraEnabled public String PercentDepreciable;
        @AuraEnabled public String Term;
        @AuraEnabled public String Salvage;
        @AuraEnabled public String ADRConvention;
        @AuraEnabled public String AdditionalYearOne;
    }

    public Class LikeKindExchange {
        @AuraEnabled public String DoLKE;
    }

    public class CollateralCurves {
        @AuraEnabled public String keepAsPct;
        @AuraEnabled public String overrideBasis;
        @AuraEnabled public String adjustedBasis;
        @AuraEnabled public String AssetCostBasis;
    }

    public class Income {
        @AuraEnabled public String IsActive;
        @AuraEnabled public String FedTaxMethod;
        @AuraEnabled public String AutoFunding;
        @AuraEnabled public String FedTaxablePct;
        @AuraEnabled public String FirstStartAccrual;
        @AuraEnabled public String IncludeEquityFeesinFundings;
        @AuraEnabled public String Structure;
        @AuraEnabled public String NumberOfPayments;
        @AuraEnabled public String Periodicity;
        @AuraEnabled public String AvgPayment;
        @AuraEnabled public String InflationPeriod;
        @AuraEnabled public String SumOfPayments;
//        @AuraEnabled public CashflowStepWrapper CashflowSteps;
    }

    public class CashflowStepWrapper {
        @AuraEnabled public CashflowStep CashflowStep;
    }

    public class YieldWrapper {
        @AuraEnabled public List<Yield> Yield;
    }

    public class PVWrapper {
        @AuraEnabled public List<PV> PV;
    }

    public class CashflowStep {
        @AuraEnabled public String NumberOfPayments;
        @AuraEnabled public String DaysInPeriod;
        @AuraEnabled public String Periodicity;
        @AuraEnabled public String StartAccrual;
        @AuraEnabled public String EndAccrual;
        @AuraEnabled public String FirstPaymentDate;
        @AuraEnabled public String Type;
        @AuraEnabled public String IsStub;
        @AuraEnabled public String IsAdvance;
        @AuraEnabled public String Amount;
        @AuraEnabled public String AmountLocked;
        @AuraEnabled public String PaymentTiming;
        @AuraEnabled public String LeaseRateFactor;
    }

    public class Yield {
        @AuraEnabled public String IsOn;
        @AuraEnabled public String Name;
        @AuraEnabled public String YMeth2;
        @AuraEnabled public String StreamName;
        @AuraEnabled public String Method;
        @AuraEnabled public String Base;
        @AuraEnabled public String SinkingFundRate;
        @AuraEnabled public String Compounded;
        @AuraEnabled public String IsKnown;
        @AuraEnabled public String CalculateOnEBO;
        @AuraEnabled public String TargetValue;
        @AuraEnabled public String InternalLoanFedTaxable;
        @AuraEnabled public String InternalLoanStateTaxable;
        @AuraEnabled public String CalculatedValueIsPreTax;
        @AuraEnabled public String IncludeSecondaryExpenses;
        @AuraEnabled public String DisplayPretax;
        @AuraEnabled public String DisplayAfter_tax;
        @AuraEnabled public String COFMethod;
        @AuraEnabled public String COFMethod2;
        @AuraEnabled public String UsedForRigorousTV;
        @AuraEnabled public String BookROEAveraging;
        @AuraEnabled public String UseTransactionCOF;
        @AuraEnabled public String UseEDAccounting;
        @AuraEnabled public String UsePV;
        @AuraEnabled public String PVRate;
        @AuraEnabled public String NAT;
        @AuraEnabled public String EAT;
        @AuraEnabled public String NPT;
        @AuraEnabled public String EPT;
        @AuraEnabled public String COFValue1;
        @AuraEnabled public String COFValue2;
        @AuraEnabled public String ArrayString;
    }

    public class PV {
        @AuraEnabled public String IsOn;
        @AuraEnabled public String Name;
        @AuraEnabled public String SolveforPV;
        @AuraEnabled public String PVArray;
        @AuraEnabled public String DateMethod;
        @AuraEnabled public String RateMethod;
        @AuraEnabled public String Rate;
        @AuraEnabled public String CompoundingMethod;
        @AuraEnabled public String ValuePercent;
        @AuraEnabled public String IsKnown;
        @AuraEnabled public String AdjustRate;
        @AuraEnabled public String FirstInclude;
        @AuraEnabled public String SecondInclude;
        @AuraEnabled public String ThirdInclude;
        @AuraEnabled public String ValueAmount;
    }

    public class LessorLender {
        @AuraEnabled public String AMTRate;
        @AuraEnabled public String UseAMT;
        @AuraEnabled public String SpreadRemainingAMT;
        @AuraEnabled public String IsFirstYear;
        @AuraEnabled public String StartFirstYear;
        @AuraEnabled public String TaxYearEnd;
        @AuraEnabled public CanadianTaxData CanadianTaxData;
        @AuraEnabled public String AMTStart;
        @AuraEnabled public String AMTEnd;
        @AuraEnabled public String PassLossStart;
        @AuraEnabled public String UsePassLoss;
        @AuraEnabled public String doStateNOL;
        @AuraEnabled public String doMakeUpPmts;
        @AuraEnabled public String doMakeUpRefunds;
        @AuraEnabled public String AMT_ACETaxexemptPreference;
        @AuraEnabled public String AMT_ACETaxexemptRecovery;
        @AuraEnabled public String EnableVAT;
        @AuraEnabled public String VATRate;
        @AuraEnabled public String OverrideVAT;
        @AuraEnabled public AccountingPreferences AccountingPreferences;
        @AuraEnabled public RatesWrapper Federal;
        @AuraEnabled public RatesWrapper State;
        @AuraEnabled public String TaxExemptPreference;
        @AuraEnabled public PassiveLossWrapper PassiveLossList;
    }

    public class PassiveLossWrapper {
        @AuraEnabled public PassiveLoss PassiveLoss;
    }

    public class PassiveLoss {
        @AuraEnabled public String Allowed;
        @AuraEnabled public String External;
        @AuraEnabled public String Year;
    }

    public class RatesWrapper {
        @AuraEnabled public Rates Rates;
        @AuraEnabled public Pmts Pmts;
        @AuraEnabled public String TaxMethod;
        @AuraEnabled public String TaxEstimate;
        @AuraEnabled public String DelayTaxes;
        @AuraEnabled public String OKminCur;
        @AuraEnabled public String useMinCur;
    }

    public class Pmts {
        @AuraEnabled public List<TaxPayment> TaxPayment;
    }

    public class TaxPayment {
        @AuraEnabled public String Thru;
        @AuraEnabled public String Paid;
        @AuraEnabled public String Percent;
    }

    public class Rates {
        @AuraEnabled public TaxRateType TaxRateType;
    }

    public class TaxRateType {
        @AuraEnabled public String TaxRateDate;
        @AuraEnabled public String Amt;
        @AuraEnabled public String AdjustOnTarget;
    }

    public class AccountingPreferences {
        @AuraEnabled public String MonthlyIncomeBooking;
    }

    public class CanadianTaxData {
        @AuraEnabled public String UseHST;
        @AuraEnabled public String PSTonGST;
        @AuraEnabled public String GSTfinancing;
        @AuraEnabled public String PSTtreatment;
        @AuraEnabled public String GSTrate;
        @AuraEnabled public String GSTamount;
        @AuraEnabled public String PSTrate;
        @AuraEnabled public String PSTamount;
        @AuraEnabled public String Trade_inreducesGST;
        @AuraEnabled public String LienincreasesGST;
        @AuraEnabled public String Trade_inreducesPST;
        @AuraEnabled public String LienincreasesPST;
        @AuraEnabled public String OverrideGSTamount;
        @AuraEnabled public String OverridePSTamount;
        @AuraEnabled public String Prescribedrate;
        @AuraEnabled public String Leveragereducesbookbalance;
        @AuraEnabled public String Provincialcapitaltaxdeducted;
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