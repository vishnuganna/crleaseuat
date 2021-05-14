/**
 * @date Apr 19, 2021
 * @description : This trigger covers existing trigger logic related to PPL Payroll object.
 */
public class PPLPayrollTriggerHandler implements ITriggerHandler {
  public void BeforeInsert(List<SObject> newItems) {
  
  }

  public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
  
  }

  public void BeforeDelete(Map<Id, SObject> oldItems) {}

  public void AfterInsert(Map<Id, SObject> newItems) {
    
    //Logic from FFPrefill_TriggerC4A02
    List<PPL_Payroll__c>  newlyInsertedItems =  [SELECT  Id ,  Final_Payroll_Link__c FROM  PPL_Payroll__c WHERE  Id  IN :trigger.new] ; 
    List<string> ids = new List<string>();
    	for ( PPL_Payroll__c e  : newlyInsertedItems) { 
    		ids.add(e.id); 
    	} 
     VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Payroll__c' ,  'Final_Payroll_Link__c' ,  'a0rf4000004dM2rAAE' ,  ids,null );  
     update newlyInsertedItems;
      
     //Logic from FFPrefill_Trigger67DD9
     List<PPL_Payroll__c>  newlyInsertedItems1 =  [SELECT  Id ,  Payroll_Link__c FROM  PPL_Payroll__c WHERE  Id  IN :trigger.new] ; 
	 List<string> ids1 = new List<string>();
     for ( PPL_Payroll__c e  : newlyInsertedItems1) { 
    	ids1.add(e.id); 
     }  
     VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'PPL_Payroll__c' ,  'Payroll_Link__c' ,  'a0rf4000004dHqJAAU' ,  ids1,null );  
     update newlyInsertedItems;
      
  }

  public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

  public void AfterDelete(Map<Id, SObject> oldItems) {}

  public void AfterUndelete(Map<Id, SObject> oldItems) {}

  
}