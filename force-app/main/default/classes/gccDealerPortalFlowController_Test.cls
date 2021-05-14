@isTest

public class gccDealerPortalFlowController_Test {


    @IsTest
    static void checkIfAccountExistsTest(){
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        acc[0].BillingPostalCode = '66210';
        update acc;
        List <Account> accntFound = new List<Account>();
        List <Account> accntToReturned = new List<Account>();
        Test.startTest();
        //System.runAs(contextuser){
            accntToReturned = gccDealerPortalFlowController.checkIfAccountExists(acc[0].Name, '66210');
            accntFound = gccDealerPortalFlowController.checkIfAccountExists(acc[0].Name,'');
        //}
        Test.stopTest();
        System.assertEquals(1, accntToReturned.size(), 'Accound Found for TestClass');
        System.assertEquals(1, accntFound.size(), 'Accound Found for TestClass');
        
    }
    
    @IsTest
    static void saveAccountTest(){
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        Test.startTest();
        //System.runAs(contextuser){
            Id accntId = gccDealerPortalFlowController.saveAccount(acc[0]);
            
        Test.stopTest();
        //System.assertEquals(1, accntToReturned.size(), 'Accound Found for TestClass');
        System.debug('Id returned is' + accntId );
        System.assertNotEquals(null, accntId, 'Value Saved');
        
        
    }

    @IsTest
    static void updateAccountContactsTest(){
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        Test.startTest();
        //System.runAs(contextuser){
        gccDealerPortalFlowController.updateAccountContacts(acc[0].Id);
            
        Test.stopTest();
        
        
        
    }

    
    @IsTest
    static void saveContactsTest(){
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        List <Contact> cont = [SELECT LastName,AccountId FROM Contact WHERE LastName ='TestContact0' ];
        Test.startTest();
        //System.runAs(contextuser){
        Id returnedid = gccDealerPortalFlowController.saveContact(cont[0],acc[0].Id);
            
        Test.stopTest();
        System.assertNotEquals(null, returnedid, 'Value Saved');
        
    }

    @IsTest
    static void saveOpportunityTest(){
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];
        List <Opportunity> oppty = [SELECT Name,Amount,Down_Payment__c,Bid_Accepted_Date__c,AccountId,Term__c,StageName,Majority_in_CA__c,App_Only_Deal__c,Replacement_Equipment__c FROM Opportunity WHERE Name ='TestOppo'];
        Test.startTest();
        //System.runAs(contextuser){
        Id returnedid = gccDealerPortalFlowController.saveOpportunity(oppty[0],acc[0].Id);
            
        Test.stopTest();
        System.assertNotEquals(null, returnedid, 'Value Saved');
        
    }


    @IsTest
    static void saveAssetTest(){
        List <Asset> assets  = [SELECT Id, Name, VIN__c, Vehicle_Type__c, Year__c, Make__c, Model__c, Engine_Model__c, Transmission_Type__c, Sleeper_Cabin__c, Sleeper_Size__c, Bunks__c, Fairings__c,
        Aluminum_Wheels__c, New_Tires__c, Number_of_New_Tires__c, APU__c
        FROM Asset WHERE VIN__c ='1FUJGEBG8HLHX2887'];
        List <Account> acc = [SELECT Name,Years_with_CDL__c,BillingAddress,Reason_for_Purchase__c,Legal_Structure__c,Email_Address__c,NumberOfEmployees,Specific_Industry__c,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode FROM Account WHERE Name ='TestAcct0'];

        Test.startTest();
        //System.runAs(contextuser){
            gccDealerPortalFlowController.saveAsset(assets[0],acc[0].Id);
            
        //}
        Test.stopTest();
        
    }

    @IsTest
    static void saveOpportunityAssetTest(){
        List <Asset> assets  = [SELECT Id, Name, VIN__c, Vehicle_Type__c, Year__c, Make__c, Model__c, Engine_Model__c, Transmission_Type__c, Sleeper_Cabin__c, Sleeper_Size__c, Bunks__c, Fairings__c,
        Aluminum_Wheels__c, New_Tires__c, Number_of_New_Tires__c, APU__c
        FROM Asset WHERE VIN__c ='1FUJGEBG8HLHX2887'];
        List <Opportunity> oppty = [SELECT Name,Amount,Down_Payment__c,Bid_Accepted_Date__c,AccountId,Term__c,StageName,Majority_in_CA__c,App_Only_Deal__c,Replacement_Equipment__c FROM Opportunity WHERE Name ='TestOppo'];
        Test.startTest();
        //System.runAs(contextuser){
         gccDealerPortalFlowController.saveOpportunityAsset(assets[0].Id,oppty[0].Id);
            
        //}
        Test.stopTest();
        
    }


    @IsTest
    static void checkIfAssetExistsTest(){
        List <Asset> assets  = [SELECT Id, Name, VIN__c, Vehicle_Type__c, Year__c, Make__c, Model__c, Engine_Model__c, Transmission_Type__c, Sleeper_Cabin__c, Sleeper_Size__c, Bunks__c, Fairings__c,
        Aluminum_Wheels__c, New_Tires__c, Number_of_New_Tires__c, APU__c
        FROM Asset WHERE VIN__c ='1FUJGEBG8HLHX2887'];
        List <Asset> recordFound = new List<Asset>();
        List <Asset> recordNotFound = new List<Asset>();
        Test.startTest();
        //System.runAs(contextuser){
            recordFound = gccDealerPortalFlowController.checkIfAssetExists(assets[0].VIN__c);
            
        //}
        Test.stopTest();
        System.assertEquals(1, recordFound.size(), 'Asset Found for TestClass');
        try{
            recordNotFound = gccDealerPortalFlowController.checkIfAssetExists('');
        }catch(Exception e){
            System.debug('exception caught in Test'+ e.getMessage());
        }
        
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