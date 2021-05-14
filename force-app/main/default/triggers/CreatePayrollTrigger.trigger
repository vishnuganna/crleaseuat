trigger CreatePayrollTrigger on PPL_Application__c (before insert) {
    for (PPL_Application__c pplApp : Trigger.New) {
        PPL_Payroll__c payrollRecord = new PPL_Payroll__c();
    	insert payrollRecord;
        
        pplApp.PPL_Payroll__c = payrollRecord.Id;
    }
	
}