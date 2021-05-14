public without sharing class gccDealerPortalFlowController {
    @AuraEnabled
    public static String getAttributes(Id sId) {
        String sobjectType = sId.getSObjectType().getDescribe().getName();
        if (sobjectType == 'GMBLBC__Redirect__c') {
            GMBLBC__Redirect__c redirect;
            for (GMBLBC__Redirect__c r : [
                    SELECT Id,
                            GMBLBC__Component_Attributes__c
                    FROM GMBLBC__Redirect__c
                    WHERE Id = :sId
                    LIMIT 1
            ]) {
                redirect = r;
            }
            if (redirect == null) {
                throw new gcException('Process Error: invalid redirect ID');
            }

            return redirect.GMBLBC__Component_Attributes__c;
        }

        if (sobjectType == 'Application__c') {
            Application__c application;
            for (Application__c applicant : [
                    SELECT Id,
                            DataMap__c
                    FROM Application__c
                    WHERE Id = :sId
                    LIMIT 1
            ]) {
                application = applicant;
            }
            if (application == null) {
                throw new gcException('Process Error: invalid Application ID');
            }

            return application.DataMap__c;
        }

        throw new gcException('Process Error: invalid sObject ID');
    }

    @AuraEnabled
    public static List<Account> checkIfAccountExists(String accName, String zip) {
        if (String.isBlank(accName)) {
            throw new AuraHandledException('Account Name can not be blank');
        }
        if (String.isBlank(zip)) {
            return [
                    SELECT Id, Name, BillingAddress, BillingCity, BillingCountry, BillingPostalCode,
                            Drivers_License_Number__c, Description, Date_of_Birth__c, Driver_s_License_Expiration_Date__c,
                            DBA__c, Years_in_Business__c, BillingStreet, BillingState, Email_Address__c, Phone, SSN__c, EIN__c
                    FROM Account
                    WHERE Name = :accName
                    LIMIT 100
            ];
        } else {
            return [
                    SELECT Id, Name, BillingAddress, BillingCity, BillingCountry, BillingPostalCode,
                            Drivers_License_Number__c, Description, Date_of_Birth__c, Driver_s_License_Expiration_Date__c,
                            DBA__c, Years_in_Business__c, BillingStreet, BillingState,  Email_Address__c, Phone, SSN__c, EIN__c
                    FROM Account
                    WHERE Name = :accName AND BillingPostalCode = :zip
                    LIMIT 100
            ];
        }
    }

    @AuraEnabled
    public static List<Asset> checkIfAssetExists(String vin) {
        if (String.isBlank(vin)) {
            throw new AuraHandledException('VIN can not be blank');
        }
        return [
                SELECT Id, Name, VIN__c, Vehicle_Type__c, Year__c, Make__c, Model__c, Engine_Model__c, Transmission_Type__c, Sleeper_Cabin__c, Sleeper_Size__c, Bunks__c, Fairings__c,
                        Aluminum_Wheels__c, New_Tires__c, Number_of_New_Tires__c, APU__c
                FROM Asset
                WHERE VIN__c = :vin
                LIMIT 100
        ];
    }

    @AuraEnabled
    public static Id saveAccount(Account account) {
        try {
            if(Account.NumberOfEmployees != null){
                Account.NumberOfEmployees = Integer.valueOf(Account.NumberOfEmployees);
            }
            List<RecordType> borrowerRecTypes = [
                    SELECT Id, DeveloperName
                    FROM RecordType
                    WHERE SobjectType = 'Account'
                    AND DeveloperName = 'Borrower'
            ];
            account.RecordTypeId = borrowerRecTypes[0].Id;
            System.debug(JSON.serialize(account));
            upsert account;
            return account.Id;
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateAccountContacts(Id accountId) {
        try {
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accountId];
            if (!contacts.isEmpty()) {
                update contacts;
            }
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id saveContact(Contact contact, Id accountId) {
        try {
            contact.AccountId = accountId;
            upsert contact;
            return contact.Id;
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id saveOpportunity(Opportunity opportunity, Id accountId) {
        try {
            opportunity.AccountId = accountId;
            opportunity.CloseDate = Date.today().addMonths(1);
            upsert opportunity;
            return opportunity.Id;
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id saveAsset(Asset asset, Id accountId) {
        try {
            asset.AccountId = accountId;
            upsert asset;
            return asset.Id;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveOpportunityAsset(Id assetId, Id opportunityId) {
        Opportunity_Asset__c opportunityAsset = new Opportunity_Asset__c();
        opportunityAsset.Opportunity__c = opportunityId;
        opportunityAsset.Asset__c = assetId;
        insert opportunityAsset;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getPicklistValues(String objectName, String fieldName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeFieldResult fieldResult = objectType.getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, String> values = new Map<String, String>();
        for (Schema.PicklistEntry f : ple) {
            values.put(f.getValue(), f.getLabel());
        }
        return values;
    }

    @AuraEnabled
    public static void updateRedirectRecord(Id redirectId, String paramsMap) {
        GMBLBC__Redirect__c redirect =  new GMBLBC__Redirect__c();
        redirect.Id = redirectId;
        redirect.GMBLBC__Component_Attributes__c = paramsMap;

        update redirect;
    }

    @AuraEnabled
    public static String sendSMS(String toNumber) {
        gcTwilioApi.GeneralApi api = new gcTwilioApi.GeneralApi();
        String body = 'Applicant Authorization Link :';

        api.sendSms(toNumber, body);
        return '';
    }

    @AuraEnabled
    public static String sendEmail(String toEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {toEmail};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Applicant Authorization');
        mail.setPlainTextBody('Applicant Authorization Link :');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return '';
    }

    @AuraEnabled
    public static List<VinConfiguration> getVinVerification(String vin) {
        gcAzureApi.DigestApi api = new gcAzureApi.DigestApi();
        List<gcAzureApi.VinResponse> vinResponses = api.getVerification(vin);
        List<VinConfiguration> specifications = new  List<VinConfiguration>();
        for (gcAzureApi.VinResponse response : vinResponses) {
            specifications.add(new VinConfiguration(response, getVinSpecification(response.configurationId)));
        }
        return specifications;
    }

    @AuraEnabled
    public static gcAzureApi.SpecificationResponse getVinSpecification(Integer specificationId) {
        gcAzureApi.DigestApi api = new gcAzureApi.DigestApi();
        gcAzureApi.SpecificationResponse specificationResponse = api.getSpecification(specificationId);
        return specificationResponse;
    }

    @AuraEnabled
    public static Map<Integer, gcAzureApi.OptionResponse> getVinOptions(Integer sizeClassId, Integer year) {
        gcAzureApi.DigestApi api = new gcAzureApi.DigestApi();
        Map<Integer, gcAzureApi.OptionResponse> optionsMap = new Map<Integer, gcAzureApi.OptionResponse>();
        optionsMap.put(67, api.getOptions(sizeClassId, year, 67));
        optionsMap.put(53, api.getOptions(sizeClassId, year, 53));
        return optionsMap;
    }

    @AuraEnabled
    public static gcAzureApi.ValueResponse getTruckValuation(Integer configurationId, Integer mileage, String condition) {
        gcAzureApi.DigestApi api = new gcAzureApi.DigestApi();
        gcAzureApi.ValueResponse specificationResponse = api.getValue(configurationId, mileage, condition);
        return specificationResponse;
    }

    @AuraEnabled
    public static ApplicantResult saveAndFinnish(String flowName, String stageName, String mapData, Id accountId, Id contactId, Id coContactId, Id opportunityId, Id applicationId, Boolean agreeConsent, Boolean isFinish) {
        try {
            Application__c application = new Application__c();
            application.Id = applicationId;
            if (agreeConsent != null) {
                application.ConsentApplied__c = agreeConsent;
            }

            if (flowName != null) {
                application.FlowName__c = flowName;
            }
            if (stageName != null) {
                application.StageName__c = stageName;
            }
            if (accountId != null) {
                application.ApplicantAccount__c = accountId;
            }
            if (contactId != null) {
                application.ApplicantContact__c = contactId;
            }
            if (coContactId != null) {
                application.CoApplicant__c = coContactId;
            }
            application.ApplicantOpportunity__c = opportunityId;
            application.DataMap__c = mapData;


            if(stageName == 'reviewDeal') {
                application.OnReviewPage__c = true;
            }

            upsert application;
            if(isFinish) {
                application = [SELECT Id, Name FROM Application__c WHERE Id = :application.Id LIMIT 1];
            }
            return new ApplicantResult(application.Id, application.Name);
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ApplicantResult {
        @AuraEnabled public String Name;
        @AuraEnabled public Id Id;

        public ApplicantResult (Id id, String name) {
            this.Id = id;
            this.Name = name;
        }
    }

    @AuraEnabled
    public static gcLexisNexisApi.VerificationResult getLexisNexisIndividualInstantId (Id contactId) {
        Contact contact = [SELECT id, FirstName, LastName, MailingStreet, HomePhone, Email,
                                  MailingCity, MailingStateCode, MailingPostalCode, SSN__c
                             FROM Contact
                            WHERE Id = :contactId];

        gcLexisNexisApi.InstantIdApi api = new gcLexisNexisApi.InstantIdApi();
        gcLexisNexisApi.VerificationResult result = api.sendIndividual(contact);
        System.debug(result);
        return result;
    }

    @AuraEnabled
    public static gcLexisNexisApi.VerificationResult getLexisNexisBusinessInstantId (Id accountId) {
        Account account = [SELECT Id, Name, Phone, EIN__c, BillingStreet, BillingCity,
                                  BillingStateCode, BillingPostalCode,
                                  (SELECT id, FirstName, LastName, MailingStreet, HomePhone,
                                          Email, MailingCity, MailingStateCode, MailingPostalCode, SSN__c
                                     FROM Contacts)
                             FROM Account
                            WHERE Id = :accountId];

        gcLexisNexisApi.InstantIdApi api = new gcLexisNexisApi.InstantIdApi();
        gcLexisNexisApi.VerificationResult result = api.sendBusiness(account, account.Contacts);
        //System.debug(result);
        return result;
    }

    @AuraEnabled
    public static Map<String, String> getSalesReps() {
        Map<String, String> values = new Map<String, String>();
        values.put(UserInfo.getUserId(), UserInfo.getFirstName() != null ? UserInfo.getFirstName() + ' ' + UserInfo.getLastName() : UserInfo.getLastName());
        for (User usr : [SELECT Id, FirstName, LastName, Name FROM User WHERE IsActive = true AND Profile.Name ='CELF User']){//Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Sales_Rep')]) {
            values.put(usr.Id, usr.FirstName != null ? usr.FirstName + ' ' +  usr.LastName : usr.LastName);
        }
        return values;
    }

    @AuraEnabled
    public static Map<String, String> getDealerships() {
        Map<String, String> values = new Map<String, String>();
        for (Dealership__c dealer : [SELECT Id, Name FROM Dealership__c]) {
            values.put(dealer.Id, dealer.Name);
        }
        return values;
    }

    @AuraEnabled
    public static List<gcPayNetDirectAPI.company_wrapper> getPaynetCompanies(Id accountId) {
        Account account = [SELECT ACCID__c,AccountNumber,AccountSource,Account_Ownership__c,AnnualRevenue,Annual_Mileage__c,
                Applicant_Type__c,Aspire_Id__c,Base_Plate__c,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,
                BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,
                CalCAP__c,ChannelProgramLevelName,ChannelProgramName,CreatedById,CreatedDate,Data_Warehouse_ID__c,Date_of_Birth__c,DBA__c,
                Description,Do_You_Haul_HAZMAT__c,Drivers_License_Number__c,Driver_s_License_Expiration_Date__c,EIN__c,Email_Address__c,
                Fax,FCAP_Program__c,FCAP_Recruiter__c,FCAP__c,Fleet_Size__c,Franchise_ID__c,Haul_Internationally__c,Haul_Type__c,Id,Industry,
                Internal_Customer_Id__c,Internal_System__c,International_Mileage__c,IsDeleted,IsPartner,Jigsaw,JigsawCompanyId,
                LASERCA__X4506_T_Email__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                Legal_Structure__c,MasterRecordId,NAICS_Code__c,NAICS_Title__c,Name,NumberOfEmployees,OwnerId,Ownership,Owner_City__c,
                Owner_Name__c,Owner_Phone__c,Owner_SSN__c,Owner_State__c,Owner_Street__c,Owner_ZIP__c,ParentId,Partner_Type__c,Phone,
                PhotoUrl,Preferred_Language__c,Previous_Financier__c,Previous_Financing__c,Rating,
//                RealZip__RealLocation_Zip__c,RealZip__RealZip_Activities_12m__c,
//                RealZip__RealZip_Activities_YTD__c,RealZip__RealZip_Count__c,RealZip__RealZip__c,
                Reason_for_Purchase__c,RecordTypeId,Risk_Tier__c,
                ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Sic,SicDesc,Site,Specific_Industry__c,SSN__c,States__c,Sub_Type__c,
                SystemModstamp,Tax_ID__c,TickerSymbol,Top_Customer__c,Total_Number_of_partners__c,Trailers__c,Type,US_DOT_Number__c,UTM_Campaign__c,
                UTM_Medium__c,UTM_Source__c,UTM_Term__c,Vetted__c,Vision_Id__c,Website,Years_in_Business__c,Years_with_CDL__c
        FROM Account
        WHERE Id = :accountId LIMIT 1];

        gcPayNetDirectAPI.PayNetDirectSoap api = new gcPayNetDirectAPI.PayNetDirectSoap();
        PayNetSettings__c paynet = PayNetSettings__c.getOrgDefaults();
        gcPayNetDirectAPI.CompanySearchResult_element companySearchResult = api.CompanySearch(
                paynet.UserName__c,
                paynet.Password__c,
                paynet.Version__c,
                account.Name,
                '',
                account.BillingStreet,
                account.BillingCity,
                account.BillingStateCode,
                account.Phone,
                account.Tax_ID__c,
                90,
                '');
        return companySearchResult.response.companies;
    }

    @AuraEnabled
    public static String getPaynetReport(Id accountId, String paynetId ) {
        PayNetSettings__c paynet = PayNetSettings__c.getOrgDefaults();
        gcPayNetDirectAPI.PayNetDirectSoap api = new gcPayNetDirectAPI.PayNetDirectSoap();
        gcPayNetDirectAPI.ReportResponse report = api.GetReport(paynet.UserName__c, paynet.Password__c, paynet.Version__c, paynetId, 'CHR', 'PDF', 'MAST', '', '');
        return AttachFile('Paynet Report ' + Datetime.now()+'.pdf', report.Files.File[0].Bytes, accountId);
    }

    @AuraEnabled
    public static String getExperianReport(Account account, Contact contactPrimary, Contact contactSecondary, Id contactPrimaryId, Id contactSecondaryId) {
        gcExperianApi.CreditReportApi api = new gcExperianApi.CreditReportApi();
        String experianToken = api.getExperianToken();
        gcExperianApi.ExperianCreditReportResponse response = api.getCreditReport(contactPrimary, contactSecondary, account, experianToken);
        String responseString = JSON.serialize(response);

        List<Contact> contactList = new List<Contact>();
        contactPrimary.Experian_Report__c = responseString;
        contactPrimary.Id = contactPrimary.Id == null ? contactPrimaryId : contactPrimary.Id;
        contactList.add(contactPrimary);

        if (contactSecondary != null) {
            contactSecondary.Experian_Report__c = responseString;
            contactSecondary.Id = contactSecondary.Id == null ? contactSecondaryId : contactSecondary.Id;
            contactList.add(contactSecondary);
        }

        if (!contactList.isEmpty()) {
            update contactList;
        }

        PageReference pdf = Page.gpExperianReport;//Replace attachmentPDf with the page you have rendered as PDF
        pdf.getParameters().put('Id', contactPrimary.Id);
        pdf.getParameters().put('report', responseString);
        pdf.setRedirect(true);

        return AttachFile('Experian Report ' + Datetime.now()+'.pdf', pdf.getContent(), contactPrimary.Id);
    }

    @AuraEnabled
    public static gcAspireApi.AspireResponse pushToAspire(Id accountId, Id opportunityId,Id contactId, List<Asset> assets) {
        try{
        Account account = [SELECT ACCID__c,AccountNumber,AccountSource,Account_Ownership__c,AnnualRevenue,Annual_Mileage__c,
                                  Applicant_Type__c,Aspire_Id__c,Base_Plate__c,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,
                                  BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,
                                  CalCAP__c,ChannelProgramLevelName,ChannelProgramName,CreatedById,CreatedDate,Data_Warehouse_ID__c,Date_of_Birth__c,DBA__c,
                                  Description,Do_You_Haul_HAZMAT__c,Drivers_License_Number__c,Driver_s_License_Expiration_Date__c,EIN__c,Email_Address__c,
                                  Fax,FCAP_Program__c,FCAP_Recruiter__c,FCAP__c,Fleet_Size__c,Franchise_ID__c,Haul_Internationally__c,Haul_Type__c,Id,Industry,
                                  Internal_Customer_Id__c,Internal_System__c,International_Mileage__c,IsDeleted,IsPartner,Jigsaw,JigsawCompanyId,
                                  LASERCA__X4506_T_Email__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                                  Legal_Structure__c,MasterRecordId,NAICS_Code__c,NAICS_Title__c,Name,NumberOfEmployees,Owner.Name,OwnerId,Ownership,Owner_City__c,
                                  Owner_Name__c,Owner_Phone__c,Owner_SSN__c,Owner_State__c,Owner_Street__c,Owner_ZIP__c,ParentId,Partner_Type__c,Phone,
                                  PhotoUrl,Preferred_Language__c,Reason_for_Purchase__c,RecordTypeId,Risk_Tier__c,
                                  ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                                  ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Sic,SicDesc,Site,Specific_Industry__c,SSN__c,States__c,Sub_Type__c,
                                  SystemModstamp,Tax_ID__c,TickerSymbol,Top_Customer__c,Total_Number_of_partners__c,Trailers__c,Type,US_DOT_Number__c,UTM_Campaign__c,
                                  UTM_Medium__c,UTM_Source__c,UTM_Term__c,Vetted__c,Vision_Id__c,Website,Years_in_Business__c,Years_with_CDL__c,State_Of_Incorporation__c,Industry_Code__c,
                                  Previous_Financing__c,Majority_in_CA__c
                             FROM Account
                            WHERE Id = :accountId LIMIT 1];

        Contact contact = [SELECT AccountId,Aspire_Id__c,AssistantName,AssistantPhone,Bankruptcy_Image__c,Bankruptcy__c,Birthdate,Business_Owner__c,CDL__c,
                                  CreatedById,CreatedDate,Credit_Score_Acceptable__c,Credit_Score_Image__c,Credit_Score__c,Data_Warehouse_Account_ID__c,
                                  Data_Warehouse_ID__c,Department,Description,DL_Class__c,DL_Expire_Date__c,DL_State__c,DoNotCall,Driver_s_License__c,
                                  Driver_Type__c,Driver__c,Email,EmailBouncedDate,EmailBouncedReason,Fax,FirstName,HasOptedOutOfEmail,HasOptedOutOfFax,HomePhone,
                                  Id,IndividualId,Internal_Customer_Id__c,Internal_System__c,IsDeleted,IsEmailBounced,Jigsaw,JigsawContactId,
                                  LASERCA__Bypass_Duplicate_Detection__c,LASERCA__Co_Applicant_DOB__c,LASERCA__Co_Applicant_Last_Name__c,LASERCA__Co_Applicant_Name__c,
                                  LASERCA__Co_Applicant_Social_Security_Number__c,LASERCA__Co_Applicant_SSN__c,LASERCA__Credit_Bureau__c,LASERCA__File_Number__c,
                                  LASERCA__Home_Address__c,LASERCA__Home_City__c,LASERCA__Home_Country__c,LASERCA__Home_State__c,LASERCA__Home_Zip__c,LASERCA__Middle_Initial__c,
                                  LASERCA__Pull_Credit_Report__c,LASERCA__Pull_Equifax_Decision_Power__c,LASERCA__Request_Credit_Bureau__c,LASERCA__Social_Security_Number__c,
                                  LASERCA__Special_Option__c,LASERCA__TIN__c,LastActivityDate,LastCURequestDate,LastCUUpdateDate,LastModifiedById,LastModifiedDate,LastName,
                                  LastReferencedDate,LastViewedDate,LeadSource,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,
                                  MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MiddleName,MobilePhone,Name,OtherAddress,OtherCity,
                                  OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,
                                  OwnerId,Percent_Ownership__c,Phone,PhotoUrl,ReportsToId,Role__c,Salutation,SSN__c,
                                  Suffix,SystemModstamp,Title,Total_Revolving_Available_image__c,Total_Revolving_Available_TRA_20_or_l__c,US_Citizen__c,Vision_Id__c,Years_as_Company_Driver__c,
                                  Years_IOO_Experience__c,Years_with_CDL__c,coApplicant__c,Is_Additional_Business_Contact__c,Opportunity_Role__c
                             FROM Contact
                             WHERE Id = :contactId LIMIT 1];

        Opportunity opportunity = [SELECT Id ,AccountId,Amount, SalesUserNum__c, AlreadyInAspire__c, Title_or_IRP_base_plate_CA__c, //Finance_Program__c,
                                    StageName, Replacement_Equipment__c,Equipment_Cost__c, OwnerId, Majority_in_CA__c, Account.Fleet_Size__c, Owner.Aspire_ID__c,
                                    Account.NumberOfEmployees, Account.AnnualRevenue, Rate__c,Term__c, DurationPrimaryHaulSouce__c,Down_Payment__c,Bid_Accepted_Date__c,
                                    App_Only_Deal__c,VPR__c,Max_Term__c,Vendor_Dealer_Reserve__c,Net_Yield_Pre_Tax_Yield__c
                                    FROM Opportunity WHERE Id = :opportunityId LIMIT 1];

        //List<Asset> assets = [SELECT Id, Name, Make__c, Year__c, Price, Mileage__c, VIN__c, Model__c, Description, Status, Asset_Type__c FROM Asset WHERE AccountId = :accountId];

        gcAspireApi.CustomerApi api = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse functionResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse customerApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse locationApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse udfApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contractApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse assetApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse assetContApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contracUDFApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contracCreditUDFApiResponse = new gcAspireApi.AspireResponse();
            //start Transaction
            api.startTransaction( String.valueOf(opportunity.AccountId));
            locationApiResponse = api.createLocation(account, contact);
            customerApiResponse = api.createCustomer(account, contact);
            udfApiResponse = api.accountUDFs(account,contact);
            contractApiResponse = api.createContract(opportunity);
            if(account.FCAP_Recruiter__c != null){
                contracUDFApiResponse = api.addcontractUDFs(account,contact,opportunity);
            }
            //commit Transaction
            api.commitTransaction(opportunity.AccountId);
            if(assets !=null){
                assetApiResponse = api.createAssets(assets);
                assetContApiResponse = api.addAssetsToContract(opportunity, assets);
            }

            if(opportunity.VPR__c !=null || opportunity.Max_Term__c != null ||
               opportunity.Net_Yield_Pre_Tax_Yield__c !=null ){
                contracCreditUDFApiResponse = api.addcontractCreditUDFs(account,contact,opportunity,'POST');

            }
           
            // Asynchronous callout for RelatedAccount
            createRelatedAccountsInAspire(opportunityId);
            if((customerApiResponse.Errors != null && customerApiResponse.Errors.size() > 0)){
                    functionResponse = customerApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(customerApiResponse.Errors[0].Messages[0],customerApiResponse.Errors[0].Code , 'gcAspire.CreateCustomer', 'Error');
                }
                else if(locationApiResponse.Errors !=null && locationApiResponse.Errors.size() > 0){
                    functionResponse = locationApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(locationApiResponse.Errors[0].Messages[0],locationApiResponse.Errors[0].Code , 'gcAspire.CreateLocation', 'Error');   
                }
                else if(contractApiResponse.Errors !=null && contractApiResponse.Errors.size() > 0){
                    functionResponse = contractApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contractApiResponse.Errors[0].Messages[0],contractApiResponse.Errors[0].Code , 'gcAspire.CreateContract', 'Error');   
                }
                else if(udfApiResponse.Errors !=null && udfApiResponse.Errors.size() > 0){
                    functionResponse = udfApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(udfApiResponse.Errors[0].Messages[0],udfApiResponse.Errors[0].Code , 'gcAspire.UDFs', 'Error');   
                }
                else if(assetApiResponse.Errors !=null && assetApiResponse.Errors.size() > 0){
                    functionResponse = assetApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(assetApiResponse.Errors[0].Messages[0],assetApiResponse.Errors[0].Code , 'gcAspire.CreateAssets', 'Error');   
                }
                else if(assetContApiResponse.Errors !=null && assetContApiResponse.Errors.size() > 0){
                    functionResponse = assetContApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(assetContApiResponse.Errors[0].Messages[0],assetContApiResponse.Errors[0].Code , 'gcAspire.CreateContractAssets', 'Error');   
                }
                else if(contracUDFApiResponse.Errors !=null && contracUDFApiResponse.Errors.size()>0 ){
                    functionResponse = contracUDFApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contracUDFApiResponse.Errors[0].Messages[0],contracUDFApiResponse.Errors[0].Code , 'gcAspire.CreateContractUDFs', 'Error');   

                }
                else if(contracCreditUDFApiResponse.Errors !=null && contracCreditUDFApiResponse.Errors.size()>0 ){
                    functionResponse = contracCreditUDFApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contracCreditUDFApiResponse.Errors[0].Messages[0],contracCreditUDFApiResponse.Errors[0].Code , 'gcAspire.CreateContractCreditUDFs', 'Error');   

                }
                else{
                    functionResponse = gcAspireApi.dummySuccessResponse();
                }

        return functionResponse ;
        
    }catch(Exception ex){
        System.debug(ex.getMessage());
        System.debug(ex.getStackTraceString());
        throw new AuraHandledException('Something went wrong in Aspire Synchonization' + ex.getMessage());

    }

    }

    @AuraEnabled
    public static gcAspireApi.AspireResponse pushToAspireforUpdate(Id accountId, Id opportunityId,Id contactId, List<Asset> assets) {
        try{
        Account account = [SELECT ACCID__c,AccountNumber,AccountSource,Account_Ownership__c,AnnualRevenue,Annual_Mileage__c,
                                  Applicant_Type__c,Aspire_Id__c,Base_Plate__c,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,
                                  BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,
                                  CalCAP__c,ChannelProgramLevelName,ChannelProgramName,CreatedById,CreatedDate,Data_Warehouse_ID__c,Date_of_Birth__c,DBA__c,
                                  Description,Do_You_Haul_HAZMAT__c,Drivers_License_Number__c,Driver_s_License_Expiration_Date__c,EIN__c,Email_Address__c,
                                  Fax,FCAP_Program__c,FCAP_Recruiter__c,FCAP__c,Fleet_Size__c,Franchise_ID__c,Haul_Internationally__c,Haul_Type__c,Id,Industry,
                                  Internal_Customer_Id__c,Internal_System__c,International_Mileage__c,IsDeleted,IsPartner,Jigsaw,JigsawCompanyId,
                                  LASERCA__X4506_T_Email__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                                  Legal_Structure__c,MasterRecordId,NAICS_Code__c,NAICS_Title__c,Name,NumberOfEmployees,Owner.Name,OwnerId,Ownership,Owner_City__c,
                                  Owner_Name__c,Owner_Phone__c,Owner_SSN__c,Owner_State__c,Owner_Street__c,Owner_ZIP__c,ParentId,Partner_Type__c,Phone,
                                  PhotoUrl,Preferred_Language__c,Reason_for_Purchase__c,RecordTypeId,Risk_Tier__c,
                                  ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                                  ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Sic,SicDesc,Site,Specific_Industry__c,SSN__c,States__c,Sub_Type__c,
                                  SystemModstamp,Tax_ID__c,TickerSymbol,Top_Customer__c,Total_Number_of_partners__c,Trailers__c,Type,US_DOT_Number__c,UTM_Campaign__c,
                                  UTM_Medium__c,UTM_Source__c,UTM_Term__c,Vetted__c,Vision_Id__c,Website,Years_in_Business__c,Years_with_CDL__c,State_Of_Incorporation__c,Industry_Code__c,
                                  Previous_Financing__c,Majority_in_CA__c
                             FROM Account
                            WHERE Id = :accountId LIMIT 1];

        Contact contact = [SELECT AccountId,Aspire_Id__c,AssistantName,AssistantPhone,Bankruptcy_Image__c,Bankruptcy__c,Birthdate,Business_Owner__c,CDL__c,
                                  CreatedById,CreatedDate,Credit_Score_Acceptable__c,Credit_Score_Image__c,Credit_Score__c,Data_Warehouse_Account_ID__c,
                                  Data_Warehouse_ID__c,Department,Description,DL_Class__c,DL_Expire_Date__c,DL_State__c,DoNotCall,Driver_s_License__c,
                                  Driver_Type__c,Driver__c,Email,EmailBouncedDate,EmailBouncedReason,Fax,FirstName,HasOptedOutOfEmail,HasOptedOutOfFax,HomePhone,
                                  Id,IndividualId,Internal_Customer_Id__c,Internal_System__c,IsDeleted,IsEmailBounced,Jigsaw,JigsawContactId,
                                  LASERCA__Bypass_Duplicate_Detection__c,LASERCA__Co_Applicant_DOB__c,LASERCA__Co_Applicant_Last_Name__c,LASERCA__Co_Applicant_Name__c,
                                  LASERCA__Co_Applicant_Social_Security_Number__c,LASERCA__Co_Applicant_SSN__c,LASERCA__Credit_Bureau__c,LASERCA__File_Number__c,
                                  LASERCA__Home_Address__c,LASERCA__Home_City__c,LASERCA__Home_Country__c,LASERCA__Home_State__c,LASERCA__Home_Zip__c,LASERCA__Middle_Initial__c,
                                  LASERCA__Pull_Credit_Report__c,LASERCA__Pull_Equifax_Decision_Power__c,LASERCA__Request_Credit_Bureau__c,LASERCA__Social_Security_Number__c,
                                  LASERCA__Special_Option__c,LASERCA__TIN__c,LastActivityDate,LastCURequestDate,LastCUUpdateDate,LastModifiedById,LastModifiedDate,LastName,
                                  LastReferencedDate,LastViewedDate,LeadSource,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,
                                  MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MiddleName,MobilePhone,Name,OtherAddress,OtherCity,
                                  OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,
                                  OwnerId,Percent_Ownership__c,Phone,PhotoUrl,ReportsToId,Role__c,Salutation,SSN__c,
                                  Suffix,SystemModstamp,Title,Total_Revolving_Available_image__c,Total_Revolving_Available_TRA_20_or_l__c,US_Citizen__c,Vision_Id__c,Years_as_Company_Driver__c,
                                  Years_IOO_Experience__c,Years_with_CDL__c,coApplicant__c,Is_Additional_Business_Contact__c,Opportunity_Role__c
                             FROM Contact
                             WHERE Id = :contactId LIMIT 1];

        Opportunity opportunity = [SELECT Id ,AccountId,Amount, SalesUserNum__c, AlreadyInAspire__c, Title_or_IRP_base_plate_CA__c, //Finance_Program__c,
                                    StageName, Replacement_Equipment__c,Equipment_Cost__c, OwnerId, Majority_in_CA__c, Account.Fleet_Size__c, Owner.Aspire_ID__c,
                                    Account.NumberOfEmployees, Account.AnnualRevenue, Rate__c,Term__c, DurationPrimaryHaulSouce__c,Down_Payment__c,Bid_Accepted_Date__c,
                                    App_Only_Deal__c,VPR__c,Max_Term__c,Vendor_Dealer_Reserve__c,Net_Yield_Pre_Tax_Yield__c
                                    FROM Opportunity WHERE Id = :opportunityId LIMIT 1];

        //List<Asset> assets = [SELECT Id, Name, Make__c, Year__c, Price, Mileage__c, VIN__c, Model__c, Description, Status, Asset_Type__c FROM Asset WHERE AccountId = :accountId];

        gcAspireApi.CustomerApi api = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse functionResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse customerApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse locationApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse udfApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contractApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse assetApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse assetContApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contracUDFApiResponse = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse contracCreditUDFApiResponse = new gcAspireApi.AspireResponse();
            
            locationApiResponse = api.updateLocation(account, contact);
            customerApiResponse = api.updateCustomer(account, contact);
            udfApiResponse = api.accountUpdateUDFs(account,contact);
            contractApiResponse = api.updateContract(opportunity);
            if(assets !=null){
                assetApiResponse = api.createAssets(assets);
                assetContApiResponse = api.addAssetsToContract(opportunity, assets);
            }
            if(account.FCAP_Recruiter__c != null){
                contracUDFApiResponse = api.contractUpdateUDFs(account,contact,opportunity);
            }
            if(opportunity.VPR__c !=null || opportunity.Max_Term__c != null ||
               opportunity.Net_Yield_Pre_Tax_Yield__c !=null ){
                contracCreditUDFApiResponse = api.addcontractCreditUDFs(account,contact,opportunity,'POST');
            }
            // Asynchronous callout for RelatedAccount
            createRelatedAccountsInAspire(opportunityId);
            if((customerApiResponse.Errors != null && customerApiResponse.Errors.size() > 0)){
                    functionResponse = customerApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(customerApiResponse.Errors[0].Messages[0],customerApiResponse.Errors[0].Code , 'gcAspire.CreateCustomer', 'Error');
                }
                else if(locationApiResponse.Errors !=null && locationApiResponse.Errors.size() > 0){
                    functionResponse = locationApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(locationApiResponse.Errors[0].Messages[0],locationApiResponse.Errors[0].Code , 'gcAspire.CreateLocation', 'Error');   
                }
                else if(contractApiResponse.Errors !=null && contractApiResponse.Errors.size() > 0){
                    functionResponse = contractApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contractApiResponse.Errors[0].Messages[0],contractApiResponse.Errors[0].Code , 'gcAspire.CreateContract', 'Error');   
                }
                else if(udfApiResponse.Errors !=null && udfApiResponse.Errors.size() > 0){
                    functionResponse = udfApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(udfApiResponse.Errors[0].Messages[0],udfApiResponse.Errors[0].Code , 'gcAspire.UDFs', 'Error');   
                }
                else if(assetApiResponse.Errors !=null && assetApiResponse.Errors.size() > 0){
                    functionResponse = assetApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(assetApiResponse.Errors[0].Messages[0],assetApiResponse.Errors[0].Code , 'gcAspire.CreateAssets', 'Error');   
                }
                else if(assetContApiResponse.Errors !=null && assetContApiResponse.Errors.size() > 0){
                    functionResponse = assetContApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(assetContApiResponse.Errors[0].Messages[0],assetContApiResponse.Errors[0].Code , 'gcAspire.CreateContractAssets', 'Error');   
                }
                else if(contracUDFApiResponse.Errors !=null && contracUDFApiResponse.Errors.size()>0 ){
                    functionResponse = contracUDFApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contracUDFApiResponse.Errors[0].Messages[0],contracUDFApiResponse.Errors[0].Code , 'gcAspire.CreateContractUDFs', 'Error');   

                }
                else if(contracCreditUDFApiResponse.Errors !=null && contracCreditUDFApiResponse.Errors.size()>0 ){
                    functionResponse = contracCreditUDFApiResponse;
                    crossRoadsUtil.insertErrorLogRecord(contracCreditUDFApiResponse.Errors[0].Messages[0],contracCreditUDFApiResponse.Errors[0].Code , 'gcAspire.UpdateContracCredittUDFs', 'Error');   

                }
                else{
                    functionResponse = gcAspireApi.dummySuccessResponse();
                }

        return functionResponse ;
        
    }catch(Exception ex){
        System.debug(ex.getMessage());
        System.debug(ex.getStackTraceString());
        throw new AuraHandledException('Something went wrong in Aspire Synchonization' + ex.getMessage());

    }

    }

    @AuraEnabled
    public static void changeContractStatus(Id opportunityId, String status, String lossReason, String notes) {
        Opportunity opportunity = new Opportunity();
        opportunity.Id = opportunityId;
        opportunity.StageName = status;
        opportunity.Loss_Reason__c = lossReason;
        try{
            update opportunity;
        }
        catch(exception e){
            system.debug('@@@@'+e);
        }
        

        System.debug(notes);
        if (String.isNotEmpty(notes)) {
            Note opportunityNote = new Note();
            opportunityNote.ParentId = opportunityId;
            opportunityNote.Title = 'Request Final Credit Approval Note: ' + Datetime.now();
            opportunityNote.Body = notes;
            insert opportunityNote;
            System.debug(opportunityNote.Id);
        }

    }

    @AuraEnabled
    public static void updateSyndicationStatus(Id opportunityId, String lender, String stage, String notes) {
        try{
        Opportunity opportunity = new Opportunity();
        SyndicationDetails__c sd = new SyndicationDetails__c();
        sd.Opportunity__c = opportunityId;
        sd.Lender_s_Name__c = lender;
        sd.Submission_Result__c = stage;
        sd.Syndication_Notes__c = notes;

        insert sd;

        /*opportunity.Id = opportunityId;
        opportunity.Lender_s_Name__c = lender;
        opportunity.Submission_Result__c = stage;
        opportunity.Syndication_Notes__c = notes;
        update opportunity;*/
    }catch (Exception ex){
        System.debug(ex.getMessage());
        throw new AuraHandledException('Something went wrong in Syndication Status Update');
    }


    }

    @AuraEnabled
    public static void multipleLenders(List<SyndicationDetails__c> lenderdata, Id opportunityId){
        try {
           
                
                for(SyndicationDetails__c lenderShipDetail:lenderdata){
                    
                    lenderShipDetail.Opportunity__c=opportunityId;
                    
                   
                }
                if(lenderdata.size()>0)
                    insert lenderdata;
                }  
           
        
      catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String AttachFile(String name, String body, Id parentId) {
        return AttachFile(name, EncodingUtil.base64Decode(body), parentId);
    }

    @AuraEnabled
    public static String AttachFile(String name, Blob body, Id parentId) {

        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = body;
        cv.Title = name;
        cv.PathOnClient = name;

        insert cv;

        String contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'I';

        insert cdl;

        return contentDocumentId;
    }

    @AuraEnabled
    public static gcSuperTrumpApi.SuperTrump_request_response getSuperTrump(Id opportunityId, String proposedStructure) {
        try{
            Opportunity opportunity = [
                    SELECT Id, Amount, Term__c, TRAC_Residual__c, Pymt_Frequency__c,
                    Financed_Fees__c, Dealer_Fee__c, Rate__c, Payment_Structure__c,
                    Payment_Timing__c, Proposed_Start_Date__c, First_Payment_Due__c
                    FROM Opportunity
                    WHERE id = :opportunityId];
            gcSuperTrumpApi api = new gcSuperTrumpApi();
            gcSuperTrumpApi.SuperTrump_request_response response = api.processXML(opportunity, proposedStructure);
            System.debug('Response SuperTrum'+ response);
            return response;
        }catch (QueryException e){
            throw new AuraHandledException('Not found record for current id');
        }catch (gcSuperTrumpApi.SuperTrumpApiException e){
            throw new AuraHandledException('SuperTrump integration error');
        }catch (Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Something went wrong');
        }
    }

    @AuraEnabled
    public static List<gcScorecardApi.ScorecardInfoResponse> getScoreCardInfo(Id opportunityId, Id accountId, Id contactId, List<Asset> assets) {

        if(assets == null){
            assets = new List<Asset>();
        }

        Opportunity opportunity = [
                SELECT Id, Dealership__r.State__c, Down_Payment__c, Security_Deposit__c, Financed_Fees__c,
                        Term__c, Amount, CalCAP__c, CreatedDate, Avg_Annual_Milage__c,
                        Industry_Experience__c, HAZMAT__c, VVG_Deal__c
                  FROM Opportunity
                 WHERE Id = :opportunityId LIMIT 1];

        Account account = [
                SELECT Id, Fleet_Size__c, Years_in_Business__c, FCAP__c, BillingStateCode
                  FROM Account
                 WHERE Id = :accountId LIMIT 1];

        Contact contact = [
                SELECT Id, Role__c, Percent_Ownership__c, CreatedDate
                  FROM Contact
                 WHERE Id = :contactId LIMIT 1];

        assets = [
                SELECT Id, VIN__c, Price_of_Unit__c, Mileage__c, Year__c, Model__c, NADA_Wholesale_OLV__c,
                        Price_Digest_Wholesale_OLV__c, Fleet_Evaluator_Wholesale_OLV__c, Engine_Make__c,
                        CreatedDate, Condition__c
                  FROM Asset
                 WHERE Id IN :assets];

        gcScorecardApi.CustomerApi api = new gcScorecardApi.CustomerApi();
        api.createOppAccount(opportunity, account);
        api.createContact(opportunity.Id, contact);
        api.createDecisionModel(opportunity);
        for (Asset asset : assets) {
            api.createAsset(opportunity, asset);
        }
        List<gcScorecardApi.ScorecardInfoResponse> response = api.getScorecardInfo(opportunity.Id);

        opportunity.ScoreCard_Response__c = JSON.serialize(response);

        update opportunity;

        return response;
    }

    public class VinConfiguration {
        @AuraEnabled public gcAzureApi.VinResponse configuration;
        @AuraEnabled public List<gcAzureApi.Specification> specifications;

        public VinConfiguration (gcAzureApi.VinResponse config, gcAzureApi.SpecificationResponse specification) {
            configuration = config;
            specifications = specification.specs;
        }
    }
	
    @AuraEnabled
    public static Account listAccount(Id accountId) {
        return [Select Applicant_Type__c,Name,EIN__c,Years_in_Business__c,Total_Number_of_partners__c from Account where id=: accountId];
    }
    
    @AuraEnabled
    public static Contact listContact(Id contactId) {
        return [Select FirstName,MiddleName,LastName,Birthdate,Driver_s_License__c,SSN__c,Phone,MailingAddress from Contact where id=: contactId];
    }
    
    @Future(Callout=true)
    private static void createRelatedAccountsInAspire(Id OpportunityId){
        try {
     
            List<OpportunityContactRole> opportunityContactRoles = [
                SELECT Id, OpportunityId, ContactId, Contact.Opportunity_Role__c,Contact.AccountId
                FROM OpportunityContactRole
                WHERE OpportunityId  = :OpportunityId
                AND Contact.Owner.Profile.Name IN ('System Administrator', 'CELF User')
        ];
        System.debug(opportunityContactRoles);
        if (opportunityContactRoles.isEmpty()) {
            return;
        }
        gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        for (OpportunityContactRole role: opportunityContactRoles) {
            Contact toUpd = new Contact(
                    Id = role.ContactId,
                    Opportunity_Role__c = role.Contact.Opportunity_Role__c,
                    AccountId = role.Contact.AccountId
                    
            );
            System.debug(toUpd);
            System.debug(role.OpportunityId);
            if (!Test.isRunningTest()) {
                relatedAccntResp = customerApi.setRelatedAccount(toUpd, role.OpportunityId);
                if((relatedAccntResp.Errors != null && relatedAccntResp.Errors.size() > 0)){
                    crossRoadsUtil.insertErrorLogRecord(relatedAccntResp.Errors[0].Messages[0],relatedAccntResp.Errors[0].Code , 'gcOpportunityContactRolrHandler.createRelatedAccountsInAspire', 'Error');
                }
            }
        }
    } catch (Exception ex) {
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(150), 'gcOpportunityContactRolrHandler.sendToAspireForCreateOrUpdate', 'Error');               
    }
    }

/**
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
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
    } */
 }