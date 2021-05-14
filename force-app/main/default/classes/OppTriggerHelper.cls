/**
 * The helper class for Opportunity Trigger
 * Created by Nikolai Ivakhnenko on 10/18/19.
 */

public with sharing class OppTriggerHelper {

    // set the SSN encrypted field from Primary Contact
    public static void setSSN(List<Opportunity> newRec, TriggerOperation op) {
        // we'll update SSN field before update or insert in order to avoid trigger recycling
        try {
            if (op == TriggerOperation.BEFORE_UPDATE || op == TriggerOperation.BEFORE_INSERT) {
                Set<Id> conIds = new Set<Id>();
                // collect primary contacts Ids
                for (Opportunity o : newRec) {
                    if (o.Primary_Contact__c != null) {
                        conIds.add(o.Primary_Contact__c);
                    }
                }
                // get contacts
                Map<Id, Contact> primaryContacts = new Map<Id, Contact>([
                        SELECT LASERCA__Social_Security_Number__c
                        FROM Contact
                        WHERE Id in :conIds
                ]);
                //fill SSN in Opportunities
                for (Opportunity o : newRec) {
                    if (o.Primary_Contact__c != null && primaryContacts.containsKey(o.Primary_Contact__c)) {
                        o.LASERCA__SSN_encrypted__c = primaryContacts.get(o.Primary_Contact__c).LASERCA__Social_Security_Number__c;
                    }
                }
            }
        } catch (Exception e) {
            throw new CustomException('Error during setting SSN for Opportunities: ' + e.getMessage() + '. ' + e.getStackTraceString());
        }
    }

    private class CustomException extends Exception{}
}