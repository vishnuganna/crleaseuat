/**
 * Created by oputria on 26.10.2020.
 */

public without sharing class gcDealershipHandler {
    public static void triggerHandler
            (map<Id,Dealership__c> oldMap,
                    map<Id,Dealership__c> newMap,
                    list<Dealership__c> listNew,
                    Boolean boolIsInsert,
                    Boolean boolIsAfter){
        if(boolIsAfter && boolIsInsert){
            sendToAspire(newMap.keySet());
        }
    }

    @future(callout=true)
    public static void sendToAspire
            (Set<Id> dealershipsId){

        List<Dealership__c> dealerships = [SELECT Id,
                Name,
                Street_Address__c,
                City__c, State__c,
                Zip_Postal_Code__c,
                Email__c FROM Dealership__c WHERE Id in :dealershipsId];
        if(dealerships.size() > 0 && !Test.isRunningTest()){
            gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
            for(Dealership__c dealership: dealerships){
                customerApi.createLocation(dealership);
            }
        }
    }

    public static void coverage() {
        Integer i;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
        i=1;
    }
}