@isTest
public with sharing class crossRoadsUtil_Test {

    @isTest static void insertErrorLogRecordTest() {
		
        List <Contact> conList =new List<Contact>();
        Contact con = new Contact(LastName ='testContact');
        conList.add(con);
        test.startTest();
            crossRoadsUtil.insertErrorLogRecord('message','Errorcode','classname','error');
        	crossRoadsUtil.insertSalesforceDB(conList, 'all');
        	
        test.stopTest();
	}
    
    @isTest static void insertDBTest() {
		
        List <Contact> conList =new List<Contact>();
        //create a contact with wrong email
        Contact con = new Contact(LastName ='testContact',Email='eeejd.com');
        conList.add(con);
        test.startTest();
            crossRoadsUtil.insertSalesforceDB(conList, 'all');
        test.stopTest();


    }

}