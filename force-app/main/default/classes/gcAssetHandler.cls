public without sharing class gcAssetHandler {
    public static void triggerHandler (map<Id,Asset> oldMap,
                                        map<Id,Asset> newMap,
                                        list<Asset> listNew,
                                        Boolean boolIsInsert,
                                        Boolean boolIsAfter) {
        if (boolIsAfter && boolIsInsert) {
            //sendToAspire(newMap.keySet());
        }
    }

    @future(callout=true)
    public static void sendToAspire (Set<Id> assetsId) {
    try {
        List<Asset> assets = [
                SELECT Id, VIN__c, Make__c, Year__c, Model__c, Description, Name, Status, Asset_Type__c
                  FROM Asset
                 WHERE Id IN :assetsId];
        if (assets.size() > 0) {
            gcAspireApi.AspireResponse response = Test.isRunningTest() == false ? new gcAspireApi.CustomerApi().createAssets(assets) : gcAspireApi.testResponse();
            for (Asset asset : assets) {
                if (response.Result != null && response.Result.Result == 'Commit') {
                    asset.Already_In_Aspire__c = true;
                    asset.Aspire_Create_Error_Response__c = '';
                } else {
                    asset.Aspire_Create_Error_Response__c = JSON.serialize(response);
                    crossRoadsUtil.insertErrorLogRecord(response.Errors[0].Messages[0],response.Errors[0].Code , 'gcAspire.createAssets', 'Error');
                }
            }
            update assets;
        }
    }catch (Exception ex) {
        crossRoadsUtil.insertErrorLogRecord(ex.getStackTraceString(),ex.getMessage().left(100), 'gcAssetHandler.sendToAspire', 'Error');               
    }
    }
}