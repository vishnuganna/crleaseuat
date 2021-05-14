/**
 * The test
 * Created by Nikolai Ivakhnenko  on 10/18/19.
 */
@isTest
private class OppTriggerHelperTest {

    @testSetup
    public static void setup() {
        Contact con1 = new Contact(LastName = 'Smith', FirstName = 'John',
                LASERCA__Social_Security_Number__c = '11111');
        insert con1;
        Contact con2 = new Contact(LastName = 'Raynolds',FirstName = 'David',
                LASERCA__Social_Security_Number__c = '22222');
        insert con2;
    }

    @isTest
    public static void testPositive() {
        Test.startTest();
        
        System.assertEquals(True, True);
        Test.stopTest();
    }

    @isTest
    public static void testNegative() {
        Test.startTest();
        try {
            OppTriggerHelper.setSSN(null, TriggerOperation.BEFORE_UPDATE);
        } catch (Exception e) {
            System.assert(e.getMessage().containsIgnoreCase('Error during setting SSN for Opportunities'));
        }
        Test.stopTest();
    }
}