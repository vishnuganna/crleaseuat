trigger CreditApplicationTrigger on Lead (after insert) {
    //CreditAppTriggerHelper.SendLeadsToStaging(Trigger.New);
}