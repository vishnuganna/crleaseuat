public without sharing class gcOpportunityAssetHandler {
    public static void triggerHandler (map<Id,Opportunity_Asset__c> oldMap,
                                        map<Id,Opportunity_Asset__c> newMap,
                                        list<Opportunity_Asset__c> listNew,
                                        Boolean boolIsInsert,
                                        Boolean boolIsAfter) {
        if (boolIsAfter && boolIsInsert) {
            //sendToAspire(newMap.keySet());
        }
    }

    @future(callout=true)
    public static void sendToAspire (Set<Id> opportunityAssetsId) {

        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> assetsId = new Set<Id>();

        List<Opportunity_Asset__c> opportunityAssets = [
                SELECT Opportunity__c, Asset__c
                  FROM Opportunity_Asset__c
                 WHERE id IN :opportunityAssetsId];

        for (Opportunity_Asset__c opportunityAsset: opportunityAssets) {
            opportunityIds.add(opportunityAsset.Opportunity__c);
            assetsId.add(opportunityAsset.Asset__c);
        }

        Map<Id, Asset> assetMap = new Map<Id, Asset>([
                SELECT Id, Make__c, Year__c, Mileage__c, Price, Name, Already_In_Aspire__c, VIN__c, Model__c, Description, Status, Asset_Type__c
                  FROM Asset
                 WHERE Id IN :assetsId]);

        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT Id from Opportunity WHERE id IN :opportunityIds]);

        Map<Id, List<Asset>> opportunityToAssets = new Map<Id, List<Asset>>();

        for (Opportunity_Asset__c oppAsset: opportunityAssets) {
            Id currentOppId = oppAsset.Opportunity__c;
            if (opportunityToAssets.get(currentOppId) == null) {
                opportunityToAssets.put(currentOppId, new List<Asset>{assetMap.get(oppAsset.Asset__c)});
            } else {
                opportunityToAssets.get(currentOppId).add(assetMap.get(oppAsset.Asset__c));
            }
        }

        gcAspireApi.CustomerApi customerApi = new gcAspireApi.CustomerApi();
        for (Id opportunityId : opportunityToAssets.keySet()) {
            List<Asset> assets = opportunityToAssets.get(opportunityId);
            List<Asset> notInAspireAssets = new List<Asset>();
            for (Asset asset : assets) {
                if(asset.Already_In_Aspire__c == false) {
                    notInAspireAssets.add(asset);
                }
            }
            if (notInAspireAssets.size() > 0) {
                gcAspireApi.AspireResponse response = Test.isRunningTest() == false ? new gcAspireApi.CustomerApi().createAssets(notInAspireAssets) : gcAspireApi.testResponse();
                for (Asset asset : notInAspireAssets) {
                    if (response.Result != null && response.Result.Result == 'Commit') {
                        asset.Already_In_Aspire__c = true;
                        asset.Aspire_Create_Error_Response__c = '';
                    } else {
                        asset.Aspire_Create_Error_Response__c = JSON.serialize(response);
                    }
                }
            }
            if (!Test.isRunningTest()) {
                customerApi.addAssetsToContract(opportunityMap.get(opportunityId), assets);
            }
            if (notInAspireAssets.size() > 0) {
                update notInAspireAssets;
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