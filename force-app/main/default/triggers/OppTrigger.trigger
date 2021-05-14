/**
 * The trigger for Opportunity object
 * Created by Nikolai Ivakhnenko on 10/18/19.
 */

trigger OppTrigger on Opportunity (before update, before insert) {
    oppTriggerHelper.setSSN(Trigger.new, Trigger.operationType);
}