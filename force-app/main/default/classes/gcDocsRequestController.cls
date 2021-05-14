public class gcDocsRequestController {

    private static final String DOCS_REQUEST_EMAIL_TEMPLATE = 'Docs_Request_Approve';

    @AuraEnabled
    public static void updateFileName(String stageTitle, List<String> documentIds){
        List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument WHERE Id IN :documentIds];
        for(ContentDocument document : documents){
            document.Title = stageTitle + ' - ' + document.Title;
        }
        update documents;
    }

    @AuraEnabled
    public static void saveParamsToDataMap(String recordId, String dataMap){
        Opportunity opp = [SELECT Data_Map__c from Opportunity WHERE Id = :recordId];
        opp.Data_Map__c = dataMap;
        update opp;
    }

    @AuraEnabled
    public static Opportunity getOpportunityById(String oppId){
        return [SELECT Id,
                    Data_Map__c,
                    First_Payment_Due__c,
                    First_Payment_Due_Options__c,
                    Industry_Code__c,
                    First_Payment_Notes__c,
                    GOT_Signature_Email__c,
                    StageName,
                    Dealership__r.Name,
                    Dealership__r.Email__c
                FROM Opportunity WHERE Id = :oppId LIMIT 1];
    }

    @AuraEnabled
    public static List<Asset> getAssetsRelatedToOpportunity(Id oppId){
        Set<Id> assetsId = new Set<Id>();
        for(Opportunity_Asset__c oppToAsset :  [SELECT Asset__c FROM Opportunity_Asset__c WHERE Opportunity__c = :oppId]){
            assetsId.add(oppToAsset.Asset__c);
        }

        List<Asset> assets = [SELECT
                                Id,
                                CrossroadsTitle__c,
                                CrossroadsReg__c,
                                IRP__c,
                                GPS_Contact__c,
                                GPS_Contact_Phone_Number__c,
                                GPS_Install_Location__c,
                                GPS_Serial_Number__c,
                                VIN__c,
                                VIN_Verification_Number__c
                              FROM Asset WHERE Id IN :assetsId];
        if(!assets.isEmpty()){
            return assets;
        }else{
            throw new AuraHandledException('Opportunity should have at least 1 asset');
        }
    }

    @AuraEnabled
    public static void submitDocsRequest(Opportunity opp){
        try{
            if(isRequireApproval(opp)){
                sendEmail(opp.Id);
            }
            updateOpportunity(opp);
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateAssets(List<Asset> assets){
        try{
            update assets;
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateOpportunity(Opportunity opp){
        try{
            update opp;
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Boolean isRequireApproval(Opportunity opp){
        return opp.First_Payment_Due_Options__c == 'Other (Requires Approval)';
    }

    private static void sendEmail(Id oppId){
        Opportunity opp = [SELECT Id, Dealership__r.Name , First_Payment_Due__c, ContactId FROM Opportunity WHERE Id = :oppId];
        EmailTemplate template = [SELECT Id, Body FROM EmailTemplate WHERE  DeveloperName = :DOCS_REQUEST_EMAIL_TEMPLATE];
        String approverEmail = Dealer_Portal__c.getInstance().Docs_Request_Approver__c;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {approverEmail});
        mail.setWhatId(opp.Id);
        mail.setTargetObjectId(opp.ContactId);
        mail.setTreatTargetObjectAsRecipient(false); //Contact doesn't use as recipient, need for all emails with template
        mail.setTemplateId(template.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}