@isTest
public with sharing class gcAspire_Test {


    @isTest static void putContractStatusTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        test.startTest();
            relatedAccntResp = apiTest.putContractStatus(String.valueOf(oppty[0].Id),'Submitted To Credit');
        test.stopTest();
    }
    @isTest static void setRelatedAccountTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp2 = new gcAspireApi.AspireResponse();
        test.startTest();
            relatedAccntResp = apiTest.setRelatedAccount(cont[0],String.valueOf(oppty[0].Id));
            relatedAccntResp2 = apiTest.setRelatedAccount('00100000203qwer','Customer',String.valueOf(oppty[0].Id));
        test.stopTest();
    }
    
	@isTest static void accountUDFsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        acc[0].Fleet_Size__c=2;
        acc[0].Years_in_Business__c =2;
        acc[0].AnnualRevenue =2122;
        acc[0].International_Mileage__c=212;
        acc[0].Majority_in_CA__c= true;
        
        update acc;
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.accountUDFs(acc[0],cont[0]);
            
        test.stopTest();
    }

    @isTest static void accountUpdateUDFsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        acc[0].Fleet_Size__c=2;
        acc[0].Years_in_Business__c =2;
        acc[0].AnnualRevenue =2122;
        acc[0].International_Mileage__c=212;
        acc[0].Majority_in_CA__c= true;
        
        update acc;
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.accountUpdateUDFs(acc[0],cont[0]);
            
        test.stopTest();
    }

    @isTest static void addContractUDFsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        acc[0].Fleet_Size__c=2;
        acc[0].Years_in_Business__c =2;
        acc[0].AnnualRevenue =2122;
        acc[0].International_Mileage__c=212;
        acc[0].Majority_in_CA__c= true;
        acc[0].FCAP__c = true;
        acc[0].FCAP_Program__c= 'USA Truck';
        acc[0].FCAP_Recruiter__c= 'Kevin Quinter';
        
        update acc;
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.addcontractUDFs(acc[0],cont[0],oppty[0]);
            
        test.stopTest();
    }

    @isTest static void contractUpdateUDFsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        acc[0].Fleet_Size__c=2;
        acc[0].Years_in_Business__c =2;
        acc[0].AnnualRevenue =2122;
        acc[0].International_Mileage__c=212;
        acc[0].Majority_in_CA__c= true;
        acc[0].FCAP__c = true;
        acc[0].FCAP_Program__c= 'USA Truck';
        acc[0].FCAP_Recruiter__c= 'Kevin Quinter';
        
        update acc;
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.contractUpdateUDFs(acc[0],cont[0],oppty[0]);
            
        test.stopTest();
    }

    @isTest static void createUpdateCustTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,Name,Birthdate,AccountId,MailingStreet,MailingCity,MailingStateCode,MailingPostalCode,MobilePhone FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c =true;
        cont[0].SSN__c = '123-67-7890';
        cont[0].Percent_Ownership__c=10;
        cont[0].phone='9090990900';
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Owner.Name,Industry_Code__c,Date_of_Birth__c,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        
        update acc;
        gcAspireApi.AspireResponse Resp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse Resp2 = new gcAspireApi.AspireResponse();
        test.startTest();
            Resp = apiTest.createCustomer(acc[0],cont[0]);
            Resp2 = apiTest.updateCustomer(acc[0],cont[0]);
        test.stopTest();
    }
    
    @isTest static void CreateUpdLocationTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,Name,AccountId,MailingAddress,MailingPostalCode,MailingStreet,MailingCity,MailingStateCode FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].Applicant_Type__c ='Company';
        acc[0].DBA__c ='yes';
        acc[0].Tax_ID__c ='12-123456';
        acc[0].State_Of_Incorporation__c = 'Kansas';
        acc[0].Previous_Financing__c=true;
        acc[0].AnnualRevenue=1200;
        acc[0].Haul_Type__c='Other';
        acc[0].Do_You_Haul_HAZMAT__c=true;
        acc[0].Annual_Mileage__c =20;
        acc[0].Haul_Internationally__c =true;
        acc[0].Fleet_Size__c=2;
        acc[0].Years_in_Business__c =2;
        acc[0].AnnualRevenue =2122;
        acc[0].International_Mileage__c=212;
        acc[0].Majority_in_CA__c= true;
        
        update acc;
        List<Dealership__c> dealer = [SELECT Name,Street_Address__c,City__c,State__c,Zip_Postal_Code__c,Email__c FROM Dealership__c WHERE Name = 'TestDealer'];
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp2 = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp3 = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp4 = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.createLocation(acc[0],cont[0]);
            relatedAccntResp2 = apiTest.updateLocation(acc[0],cont[0]);
            relatedAccntResp3 = apiTest.createLocation(dealer[0]);
        	relatedAccntResp4 = apiTest.updateLocation(dealer[0]);
        test.stopTest();
    }

    
    @isTest static void createUpdContractTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Opportunity> oppty = [SELECT Name,Amount,Down_Payment__c,Bid_Accepted_Date__c,AccountId,Term__c,StageName,Majority_in_CA__c,App_Only_Deal__c,Replacement_Equipment__c FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp2 = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.createContract(oppty[0]);
        	relatedAccntResp2 = apiTest.updateContract(oppty[0]);
            
        test.stopTest();
    }

    @isTest static void addcontractCreditUDFsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        System.assertEquals('TestContact0', cont[0].LastName);
        cont[0].Opportunity_Role__c = 'Customer';
        cont[0].coApplicant__c = true;
        cont[0].Is_Additional_Business_Contact__c = false;
        cont[0].Years_with_CDL__c =2;
        Update cont;
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        List <Opportunity> oppty = [SELECT Name,VPR__c,Max_Term__c,Net_Yield_Pre_Tax_Yield__c,Amount,Down_Payment__c,Bid_Accepted_Date__c,AccountId,Term__c,StageName,Majority_in_CA__c,App_Only_Deal__c,Replacement_Equipment__c FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        oppty[0].Net_Yield_Pre_Tax_Yield__c = 2200;
        Update oppty;
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        
        
        test.startTest();
            relatedAccntResp = apiTest.addcontractCreditUDFs(acc[0],cont[0],oppty[0],'POST');
        	
            
        test.stopTest();
    }
    
    @isTest static void createAssetsTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        List <Asset> assets = [SELECT Name,Description,Price,Status,VIN__c,Make__c,Year__c,Model__c,Asset_Type__c,Mileage__c
                               FROM Asset WHERE Name ='Test' ];
        System.assertEquals('Test', assets[0].Name);
        List <Opportunity> oppty = [SELECT Name,AccountId,Term__c,Equipment_Cost__c,StageName,Majority_in_CA__c,App_Only_Deal__c,Replacement_Equipment__c FROM Opportunity WHERE Name ='TestOppo'];
        System.assertEquals('TestOppo', oppty[0].Name);
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        gcAspireApi.AspireResponse relatedAccntResp2 = new gcAspireApi.AspireResponse();
        
        test.startTest();
            relatedAccntResp = apiTest.createAssets(assets);
        	relatedAccntResp2 = apiTest.addAssetsToContract(oppty[0],assets);
            
        test.stopTest();
    }
    
    @isTest static void createCommentTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        Date expirationdate = Date.newInstance(2021, 4, 17);
        test.startTest();
            relatedAccntResp = apiTest.createComment('00010002002','00010002002','code','description','subject',
                                                    'text','importance','commentTypeCode','commentTypeDescription',expirationdate,
                                                    'regardingAccountId');
        	
            
        test.stopTest();
    }
    
    @isTest static void createBankAccountTest() {
        gcAspireApi.CustomerApi apiTest = new gcAspireApi.CustomerApi();
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        Date inactiveDate = Date.newInstance(2021, 4, 17);
        test.startTest();
            relatedAccntResp = apiTest.createBankAccount('00010002002','00010002002','accountNumber','type','category',
                                                    true,inactiveDate);
        	
        test.stopTest();
    }

    @isTest static void dummyResponseAPITest() {
       
        gcAspireApi.AspireResponse relatedAccntResp = new gcAspireApi.AspireResponse();
        test.startTest();
            relatedAccntResp = gcAspireApi.dummySuccessResponse();
        test.stopTest();    

    }
    @testSetUp  static void setupTestData() {
        // Create common test accounts
        Integer recCount  = 1;
        Integer recordCount =0;
        List<Account> testAccts = new List<Account>();
        for(Integer i=0; i < recCount ; i++) {
            Account testAcc = new Account(Name = 'TestAcct'+i,Email_Address__c='test@testcompany.com',Legal_Structure__c='Corporation',NumberOfEmployees=10,
                                         Specific_Industry__c='testIndustry',Years_with_CDL__c=10,Reason_for_Purchase__c='New Equipment');
            testAccts.add(testAcc);
        }
        insert testAccts;  
        recordCount = [Select Count() from Account];
        System.assertEquals(1, recordCount, 'Account records Created');
    
        
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<2;i++) {
            Contact con = new Contact (LastName = 'TestContact'+i);
            con.AccountID = testAccts[0].Id;
            testContacts.add(con);
        }
        insert testContacts;
        recordCount = [Select Count() from Contact];
        System.assertEquals(2, recordCount, 'Contact records Created');


        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'TestOppo';
        opportunity.StageName = 'Submitted to Credit';
        opportunity.CloseDate = Date.today();
        opportunity.AccountId = testAccts[0].Id;
        opportunity.Primary_Contact__c = testContacts[0].Id;
        opportunity.Referral_Contact__c = testContacts[1].Id;
        insert opportunity;
        recordCount = [Select Count() from opportunity];
        System.assertEquals(1, recordCount, 'opportunity records Created');

        Asset asset = new Asset();
        asset.Name = 'Test';
        asset.AccountId = testAccts[0].Id;
        asset.VIN__c = '1FUJGEBG8HLHX2887';
        insert asset;
        recordCount = [Select Count() from Asset];
        System.assertEquals(1, recordCount, 'Asset records Created');

        /**Opportunity_Asset__c opportunityAsset = new Opportunity_Asset__c();
        opportunityAsset.Opportunity__c = opportunity.Id;
        opportunityAsset.Asset__c = asset.Id;
        insert opportunityAsset;
        recordCount = [Select Count() from opportunityAsset];
        System.assertEquals(1, recordCount, 'opportunityAsset records Created');
        **/
        OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
        opportunityContactRole.ContactId = testContacts[0].Id;
        opportunityContactRole.OpportunityId = opportunity.Id;
        insert opportunityContactRole;
        recordCount = [Select Count() from OpportunityContactRole];
        System.assertEquals(1, recordCount, 'OpportunityContactRole records Created');
        
        Dealership__c dealership = new Dealership__c();
        dealership.Name = 'TestDealer';
        insert dealership;
        recordCount = [Select Count() from Dealership__c];
        System.assertEquals(1, recordCount, 'Dealership__c records Created');
        
    }
}