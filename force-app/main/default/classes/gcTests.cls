@isTest
private class gcTests {
    @isTest
    static void coverageTest() {
        Test.startTest();

        gcApplicationHandler.coverage();
        gcAspireApi.coverage();
        gcAzureApi.coverage();
        //gccDealerPortalFlowController.coverage();
        gcDriverLicensePDF417.coverage();
        gcDriverLicensePDF417SampleData.coverage();
        gcDriversLicenseTakePhoto.coverage();
        gcExperianApi.coverage();
        gcLexisNexisApi.coverage();
        gcPayNetDirectAPI.coverage();
        gcScanDriverLicense.coverage();
        gcTwilioApi.coverage();
        gcDealershipHandler.coverage();
        gcOpportunityAssetHandler.coverage();
        gcScorecardApi.coverage();
        gcSuperTrumpApi.coverage();

        Test.stopTest();
    }

    @isTest
    static void gtApplicationTest() {
        Application__c application = new Application__c();
        insert application;
        update application;
    }

    @isTest
    static void Account_Contact_Opportunity_Asset_Test() {
        Account account = new Account();
        account.Name = 'Test';
        insert account;

        account.Name = 'UPD Test';
        update account;

        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        insert contact;

        contact.LastName = 'Test';
        update contact;

        Contact contact2 = new Contact();
        contact2.LastName = 'Test2';
        contact2.AccountId = account.Id;
        insert contact2;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test';
        opportunity.StageName = 'Submitted to Credit';
        opportunity.CloseDate = Date.today();
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Referral_Contact__c = contact2.Id;
        insert opportunity;

        Asset asset = new Asset();
        asset.Name = 'Test';
        asset.AccountId = account.Id;
        insert asset;

        Opportunity_Asset__c opportunityAsset = new Opportunity_Asset__c();
        opportunityAsset.Opportunity__c = opportunity.Id;
        opportunityAsset.Asset__c = asset.Id;
        insert opportunityAsset;

        OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
        opportunityContactRole.ContactId = contact.Id;
        opportunityContactRole.OpportunityId = opportunity.Id;
        insert opportunityContactRole;
    }

    @isTest
    static void gtDealerShipTest() {
        Dealership__c dealership = new Dealership__c();
        dealership.Name = 'Test';
        insert dealership;
        dealership.Name = 'UPD Test';
        update dealership;
    }

    @isTest
    static void gpExperianReportTest() {

        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.Experian_Report__c = '{"creditProfile":[{"headerRecord":[{"reportDate":"111320","reportTime":"101503","preamble":"TCA5","versionNo":"07","mKeywordLength":"00","y2kReportedDate":"11132020"}],"addressInformation":[{"city":"SANTAMARIA","dwellingType":"M","firstReportedDate":"07222011","lastReportingSubscriberCode":"1323230","lastUpdatedDate":"04152014","source":"2","state":"CA","streetName":"VINE","streetPrefix":"614","streetSuffix":"ST","timesReported":"00","zipCode":"934543745"},{"city":"SANTAMARIA","dwellingType":"S","firstReportedDate":"02142007","lastUpdatedDate":"04142011","source":"1","state":"CA","streetName":"AGNES","streetPrefix":"420","streetSuffix":"AVE","timesReported":"00","zipCode":"934582844"},{"city":"SANTAMARIA","dwellingType":"S","firstReportedDate":"08012002","lastUpdatedDate":"12082007","source":"1","state":"CA","streetName":"CRESTON","streetPrefix":"326W","streetSuffix":"ST","timesReported":"10","zipCode":"934581718"}],"consumerAssistanceReferralAddress":{"cityStateZip":"ALLEN,TX75013","officeName":"EXPERIAN","phone":"8883973742","poBox":"POBOX2002","streetName":"701EXPERIANPARKWAY"},"consumerIdentity":{"dob":{"day":"28","month":"09","year":"1948"},"name":[{"firstName":"ALFRED","middleName":"T","surname":"BONHOMME"}]},"employmentInformation":[{"firstReportedDate":"12282012","lastUpdatedDate":"12282012","name":"UNEMPLOYED","source":"2"}],"informationalMessage":[{"messageNumber":"92","messageNumberDetailed":"0092","messageText":"REQUESTEDPRODUCTOPTIONNOTALLOWED"}],"inquiry":[{"amount":"UNKNOWN","date":"04222019","kob":"FF","subscriberCode":"2611237","subscriberName":"ALLYFINANCIAL","terms":"UNK","type":"31"}],"ofac":{"messageNumber":"1202","messageText":"OFACNORECORDFOUND"},"summaries":[{"summaryType":"ProfileSummary","attributes":[{"id":"disputedAccountsExcluded","value":"000"},{"id":"publicRecordsCount","value":"000"},{"id":"installmentBalance","value":"00025105"},{"id":"realEstateBalance","value":"00161688"},{"id":"revolvingBalance","value":"00000636"},{"id":"pastDueAmount","value":"00000000"},{"id":"monthlyPayment","value":"00000718"},{"id":"monthlyPaymentPartialFlag"},{"id":"realEstatePayment","value":"00001726"},{"id":"realEstatePaymentPartialFlag"},{"id":"revolvingAvailablePercent","value":"096"},{"id":"revolvingAvailablePartialFlag"},{"id":"totalInquiries","value":"001"},{"id":"inquiriesDuringLast6Months","value":"000"},{"id":"totalTradeItems","value":"012"},{"id":"paidAccounts","value":"009"},{"id":"satisfactoryAccounts","value":"011"},{"id":"nowDelinquentDerog","value":"000"},{"id":"wasDelinquentDerog","value":"001"},{"id":"oldestTradeDate","value":"05081994"},{"id":"delinquencies30Days","value":"01"},{"id":"delinquencies60Days","value":"00"},{"id":"delinquencies90to180Days","value":"00"},{"id":"derogCounter","value":"00"}]}],"riskModel":[{"evaluation":"P","modelIndicator":"F9","score":"0813","scoreFactors":[{"importance":"1","code":"18"},{"importance":"2","code":"05"},{"importance":"3","code":"12"},{"importance":"4","code":"13"}]}],"ssn":[{"number":"666020682","ssnIndicators":"YYYYYYYYY"}],"tradeline":[{"accountNumber":"736956848","accountType":"13","amount1":"00015642","amount1Qualifier":"O","balanceDate":"06282020","delinquencies30Days":"01","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"complianceCondition":"XA","enhancedAccountCondition":"A2","enhancedAccountType":"3A","enhancedPaymentHistory84":"BBCBCBCBCBCBCBC--CCCCCCCCCCCCCCCC1CCCCCCCC","enhancedPaymentStatus":"31","enhancedSpecialComment":"19","enhancedTerms":"048","enhancedTermsFrequency":"M","firstDelinquencyDate":"09012017","maxDelinquencyCode":"1","originalLoanAmount":"0000015642","paymentLevelDate":"05012020"},"evaluation":"N","kob":"BB","lastPaymentDate":"06272019","maxDelinquencyDate":"09012017","monthsHistory":"42","openDate":"05252015","openOrClosed":"C","paymentHistory":"BBCBCBCBCBCBCBC--CCCCCCCC","revolvingOrInstallment":"I","specialComment":"19","status":"51","statusDate":"05012020","subscriberCode":"3144930","subscriberName":"FIFTHTHIRDBANKNA","terms":"048"},{"accountNumber":"500036546","accountType":"78","amount1":"00015125","amount1Qualifier":"O","balanceDate":"09062020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"enhancedAccountCondition":"A2","enhancedAccountType":"78","enhancedPaymentHistory84":"BCCCC0","enhancedPaymentStatus":"11","enhancedTerms":"060","enhancedTermsFrequency":"M","originalLoanAmount":"0000015125","paymentLevelDate":"09012020"},"evaluation":"P","kob":"FL","lastPaymentDate":"08042020","monthsHistory":"06","openDate":"04012020","openOrClosed":"C","paymentHistory":"BCCCC0","revolvingOrInstallment":"I","status":"12","statusDate":"09012020","subscriberCode":"2805210","subscriberName":"FIRFEDLS&L/FHLMC","terms":"060"},{"accountNumber":"1291131130","accountType":"07","amount1":"UNKNOWN","balanceDate":"08282020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"complianceCondition":"XA","creditLimitAmount":"UNKNOWN","enhancedAccountCondition":"A2","enhancedAccountType":"07","enhancedPaymentHistory84":"B00000000000000000000000000000000000000000000000000000000000000000000000","enhancedPaymentStatus":"11","enhancedSpecialComment":"19","enhancedTerms":"REV","enhancedTermsFrequency":"M","paymentLevelDate":"08012020"},"evaluation":"N","kob":"DC","monthsHistory":"72","openDate":"04282011","openOrClosed":"C","paymentHistory":"B000000000000000000000000","revolvingOrInstallment":"R","specialComment":"19","status":"12","statusDate":"08012020","subscriberCode":"3321860","subscriberName":"SYNCB/JCP","terms":"REV"},{"accountNumber":"448929876009","accountType":"47","amount1":"00024000","amount1Qualifier":"L","amount2":"00000050","amount2Qualifier":"H","balanceDate":"06282020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"2","enhancedPaymentData":{"complianceCondition":"XA","creditLimitAmount":"0000024000","enhancedAccountCondition":"A2","enhancedAccountType":"89","enhancedPaymentHistory84":"B0000000000000000000CC000000000000000-0000-00","enhancedPaymentStatus":"11","enhancedSpecialComment":"19","enhancedTerms":"LOC","enhancedTermsFrequency":"M","highBalanceAmount":"0000000050","paymentLevelDate":"06012020"},"evaluation":"N","kob":"BC","monthsHistory":"45","openDate":"09282016","openOrClosed":"C","paymentHistory":"B0000000000000000000CC000","revolvingOrInstallment":"R","specialComment":"19","status":"12","statusDate":"06012020","subscriberCode":"2250062","subscriberName":"PNCBANK","terms":"REV"},{"accountNumber":"045905454137","accountType":"00","amount1":"00025512","amount1Qualifier":"O","balanceDate":"07012019","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"enhancedAccountCondition":"A2","enhancedAccountType":"00","enhancedPaymentHistory84":"BCC","enhancedPaymentStatus":"11","enhancedTerms":"060","enhancedTermsFrequency":"M","originalLoanAmount":"0000025512","paymentLevelDate":"07012019"},"evaluation":"P","kob":"FA","monthsHistory":"03","openDate":"04222019","openOrClosed":"C","paymentHistory":"BCC","revolvingOrInstallment":"I","status":"12","statusDate":"07012019","subscriberCode":"2610045","subscriberName":"GMAC","terms":"060"},{"accountNumber":"4331693554","accountType":"26","amount1":"00223000","amount1Qualifier":"O","balanceDate":"04072018","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"2","enhancedPaymentData":{"enhancedAccountCondition":"A2","enhancedAccountType":"26","enhancedPaymentHistory84":"BCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"180","originalLoanAmount":"0000223000","paymentLevelDate":"04012018"},"evaluation":"P","kob":"BB","monthsHistory":"08","openDate":"07252017","openOrClosed":"C","paymentHistory":"BCCCCCCC","revolvingOrInstallment":"I","status":"12","statusDate":"04012018","subscriberCode":"2993434","subscriberName":"PNCBANK","terms":"180"},{"accountNumber":"4330839028","accountType":"26","amount1":"00232000","amount1Qualifier":"O","balanceDate":"08072017","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"2","enhancedPaymentData":{"enhancedAccountCondition":"A2","enhancedAccountType":"26","enhancedPaymentHistory84":"BCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"180","originalLoanAmount":"0000232000","paymentLevelDate":"08012017"},"evaluation":"P","kob":"BB","monthsHistory":"11","openDate":"08282016","openOrClosed":"C","paymentHistory":"BCCCCCCCCCC","revolvingOrInstallment":"I","status":"12","statusDate":"08012017","subscriberCode":"2993434","subscriberName":"PNCBANK","terms":"180"},{"accountNumber":"136325055","accountType":"18","amount1":"00006978","amount1Qualifier":"L","amount2":"00006978","amount2Qualifier":"H","balanceDate":"08012017","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"complianceCondition":"XA","creditLimitAmount":"0000006978","enhancedAccountCondition":"A2","enhancedAccountType":"18","enhancedPaymentHistory84":"BBBBBBB00CC0C0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00CC0C-0CCCCCCCCCCCCC0CCCCCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedSpecialComment":"19","enhancedTerms":"REV","enhancedTermsFrequency":"M","highBalanceAmount":"0000006978","paymentLevelDate":"02012017"},"evaluation":"N","kob":"FC","monthsHistory":"99","openDate":"05081994","openOrClosed":"C","paymentHistory":"BBBBBBB00CC0C0CCCCCCCCCCC","revolvingOrInstallment":"R","specialComment":"19","status":"12","statusDate":"02012017","subscriberCode":"2710021","subscriberName":"MSUFEDERALCREDITUNI","terms":"REV"},{"accountNumber":"4339409790","accountType":"26","amount1":"00247000","amount1Qualifier":"O","balanceDate":"09072016","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"enhancedAccountCondition":"A2","enhancedAccountType":"26","enhancedPaymentHistory84":"BCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"348","originalLoanAmount":"0000247000","paymentLevelDate":"09012016"},"evaluation":"P","kob":"BB","monthsHistory":"37","openDate":"07042014","openOrClosed":"C","paymentHistory":"BCCCCCCCCCCCCCCCCCCCCCCCC","revolvingOrInstallment":"I","status":"12","statusDate":"09012016","subscriberCode":"2993434","subscriberName":"PNCBANK","terms":"348"},{"accountNumber":"500035417","accountType":"78","amount1":"00037300","amount1Qualifier":"O","balanceAmount":"00025105","balanceDate":"09062020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"enhancedAccountCondition":"A1","enhancedAccountType":"78","enhancedPaymentHistory84":"CCCCCCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"060","enhancedTermsFrequency":"M","originalLoanAmount":"0000037300","paymentLevelDate":"09012020"},"evaluation":"P","kob":"FL","lastPaymentDate":"08142020","monthlyPaymentAmount":"00000703","monthlyPaymentType":"S","monthsHistory":"15","openDate":"06102019","openOrClosed":"O","paymentHistory":"CCCCCCCCCCCCCCC","revolvingOrInstallment":"I","status":"11","statusDate":"09012020","subscriberCode":"2805210","subscriberName":"FIRFEDLS&L/FHLMC","terms":"060"},{"accountNumber":"4332438030","accountType":"26","amount1":"00215000","amount1Qualifier":"O","balanceAmount":"00161688","balanceDate":"09052020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"2","enhancedPaymentData":{"enhancedAccountCondition":"A1","enhancedAccountType":"26","enhancedPaymentHistory84":"CCCCCCCCCCCCCCCCCCCCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"168","enhancedTermsFrequency":"M","originalLoanAmount":"0000215000","paymentLevelDate":"09012020","secondaryAgencyCode":"02","secondaryAgencyId":"722333113"},"evaluation":"P","kob":"BB","lastPaymentDate":"08102020","monthlyPaymentAmount":"00001726","monthlyPaymentType":"S","monthsHistory":"29","openDate":"03272018","openOrClosed":"O","paymentHistory":"CCCCCCCCCCCCCCCCCCCCCCCCC","revolvingOrInstallment":"I","status":"11","statusDate":"09012020","subscriberCode":"2993434","subscriberName":"PNCBANK","terms":"168"},{"accountNumber":"136325855","accountType":"18","amount1":"00020000","amount1Qualifier":"L","amount2":"00006818","amount2Qualifier":"H","balanceAmount":"00000636","balanceDate":"09012020","delinquencies30Days":"00","delinquencies60Days":"00","delinquencies90to180Days":"00","derogCounter":"00","ecoa":"1","enhancedPaymentData":{"creditLimitAmount":"0000020000","enhancedAccountCondition":"A1","enhancedAccountType":"18","enhancedPaymentHistory84":"CCCCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC","enhancedPaymentStatus":"11","enhancedTerms":"REV","enhancedTermsFrequency":"M","highBalanceAmount":"0000006818","paymentLevelDate":"09012020"},"evaluation":"P","kob":"FC","lastPaymentDate":"08032020","monthlyPaymentAmount":"00000015","monthlyPaymentType":"S","monthsHistory":"46","openDate":"11222016","openOrClosed":"O","paymentHistory":"CCCCCCCCCCCCCC0CCCCCCCCCC","revolvingOrInstallment":"R","status":"11","statusDate":"09012020","subscriberCode":"2710021","subscriberName":"MSUFEDERALCREDITUNI","terms":"REV"}],"endTotals":[{"totalSegments":"026","totalLength":"05262"}]}]}';
        insert contact;

        ApexPages.StandardController standardController = new ApexPages.StandardController(contact);

        Test.startTest();
        gcExperianReportController controller = new gcExperianReportController(standardController);
        Test.stopTest();
    }
}