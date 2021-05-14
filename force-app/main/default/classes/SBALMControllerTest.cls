@isTest
Private inherited sharing class SBALMControllerTest {
    @testSetup
    private static void setup() {
    Opportunity oppDetail=new Opportunity();
    oppDetail.Name='Test';
    oppDetail.StageName='Qualification';
    oppDetail.CloseDate=System.today() + 5;
    insert oppDetail;
    // Create common test SBALM
    List<SBALM__c> SBALMList = new List<SBALM__c>();
    for(Integer i=0;i<2;i++) {
        SBALMList.add(new SBALM__c(SBALM_LOAN_AMT__c = i,SBALM_Opportunity__c=oppDetail.id));
    }
    insert SBALMList;   
    }
    @isTest
    public static void getSBALMListTest() {
        Opportunity OpportunitiesDetail=[SELECT ID FROM Opportunity LIMIT 1];
        Test.startTest();
        SBALMController.getSBALMList(OpportunitiesDetail.ID);
        Test.stopTest();
        System.assert(SBALMController.getSBALMList(OpportunitiesDetail.ID)!=null,'SBALM DATA NOT NULL');
    }
}