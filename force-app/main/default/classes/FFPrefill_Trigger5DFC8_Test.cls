/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
@IsTest
private class FFPrefill_Trigger5DFC8_Test
{
    @IsTest
private static void testTrigger()
    {
   Test.startTest();
   PPL_Application__c primaryObject= new PPL_Application__c( Excluded_by_Federal_Agency__c=getPickValue('PPL_Application__c','Excluded_by_Federal_Agency__c'), Delinquent_or_Defaulted_Loan__c=getPickValue('PPL_Application__c','Delinquent_or_Defaulted_Loan__c'), Other_Business_Affiliations__c=getPickValue('PPL_Application__c','Other_Business_Affiliations__c'), Receieved_Disaster_Loan__c=getPickValue('PPL_Application__c','Receieved_Disaster_Loan__c'), Subject_to_Indictment__c=getPickValue('PPL_Application__c','Subject_to_Indictment__c'), TIN_Type__c=getPickValue('PPL_Application__c','TIN_Type__c'), Felony__c=getPickValue('PPL_Application__c','Felony__c'), US_Principal_Residence__c=getPickValue('PPL_Application__c','US_Principal_Residence__c'), Franchise_Directory__c=getPickValue('PPL_Application__c','Franchise_Directory__c'), Loan_Use_Payroll__c=getPickValue('PPL_Application__c','Loan_Use_Payroll__c'), Loan_Use_Interest__c=getPickValue('PPL_Application__c','Loan_Use_Interest__c'), Loan_Use_Utilities__c=getPickValue('PPL_Application__c','Loan_Use_Utilities__c'), Other_LU__c=getPickValue('PPL_Application__c','Other_LU__c'), Customer_Source__c=getPickValue('PPL_Application__c','Customer_Source__c'), In_Operation_Before_2_15_2020__c=getPickValue('PPL_Application__c','In_Operation_Before_2_15_2020__c'), Maintain_Payroll__c=getPickValue('PPL_Application__c','Maintain_Payroll__c'), Not_Engaged_In_Illegal_Activity__c=getPickValue('PPL_Application__c','Not_Engaged_In_Illegal_Activity__c'), Uncertainty_in_Economy__c=getPickValue('PPL_Application__c','Uncertainty_in_Economy__c'), X500_or_Fewer_FTEs__c=getPickValue('PPL_Application__c','X500_or_Fewer_FTEs__c'), Form_941_Confirmation__c=getPickValue('PPL_Application__c','Form_941_Confirmation__c'), Stage__c=getPickValue('PPL_Application__c','Stage__c'));
 insert primaryObject;
   Test.stopTest(); 
 System.assertNotEquals(primaryObject.Id,null);   
 }

 static String getPickValue(String objName, String fld){ 
 String firstPicklistVal=''; 
  Schema.SObjectType sobjectType= Schema.getGlobalDescribe().get(objName);   
  // Get a map of fields for the SObject 
 map<String, Schema.SObjectField> fieldMap = sobjectType.getDescribe().fields.getMap(); 
  // Get the list of picklist values for this field. 
 list<Schema.PicklistEntry> values = 
 fieldMap.get(fld).getDescribe().getPickListValues(); 
 // Add these values to the selectoption list. 
 if(values!=null && values.size()>0){ firstPicklistVal=values[0].getValue()+'';} 
 return firstPicklistVal; 
 } 

}