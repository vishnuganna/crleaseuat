/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to PPL Application object.
 */
public class PPLApplicationTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {
   
      //Logic from CreatePayrollTrigger 
      for (PPL_Application__c pplApp : (List<PPL_Application__c>)Trigger.New) {
        PPL_Payroll__c payrollRecord = new PPL_Payroll__c();
        insert payrollRecord;
        
        pplApp.PPL_Payroll__c = payrollRecord.Id;
    }
  
  }

  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
  
  }

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
      
    //Logic from FFPrefill_Trigger5DFC8  
    List<PPL_Application__c>  newlyInsertedItems =  [SELECT  Id ,  Survey_Link__c FROM  PPL_Application__c WHERE  Id  IN :trigger.new] ; 
    List<string> ids = new List<string>();
     for ( PPL_Application__c e  : newlyInsertedItems) { 
        ids.add(e.id); 
     } 
    VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Application__c' ,  'Survey_Link__c' ,  'a0rf4000004eEBgAAM' ,  ids,null );  
    update newlyInsertedItems;
      
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}