public with sharing class LeadVSBAController {
    @AuraEnabled
    public static lead createLead(lead leadeDeatil,list<Ownership__c> ownershipList,String b64SignData ){
        try {
            if(leadeDeatil!=null){
                leadeDeatil.company='VSBA';
                leadeDeatil.LeadSource='SLP Prequal Portal';
                leadeDeatil.Signature__c='<img src="data:image/jpeg;base64,'+b64SignData+'">';
                insert leadeDeatil;
               
                List<Ownership__c> ownerShipRecordList=new list<Ownership__c>();
                for(Ownership__c ownerShipDetail:ownershipList){
                    if(leadeDeatil.id!=null)
                    ownerShipDetail.lead__c=leadeDeatil.id;
                    
                    ownerShipRecordList.add(ownerShipDetail);
                }
                if(ownerShipRecordList.size()>0)
                    insert ownerShipRecordList;

                
               
                return leadeDeatil;
            }else {
                return leadeDeatil;
            }
                
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    private static void uploadSignature(String leadID, String b64SignData){
        
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Signature_'+String.valueOf(Date.today()).substring(0,10);
            cv.PathOnClient = '/' + 'Signature_'+String.valueOf(Date.today()).substring(0,10);
            cv.FirstPublishLocationId = leadID;
            cv.VersionData = EncodingUtil.base64Decode(b64SignData);
            cv.IsMajorVersion = true;
            Insert cv;
        }
    
    @AuraEnabled
    public static void createLeadWithDecline(lead leadeDeatil,list<Ownership__c> ownershipList){
        try {
                
                if(leadeDeatil!=null){
                leadeDeatil.company='VSBA';
                leadeDeatil.LeadSource='SLP Prequal Portal';
                leadeDeatil.Status='Non-Lead';
                upsert leadeDeatil;
                List<Ownership__c> ownerShipRecordList=new list<Ownership__c>();
                for(Ownership__c ownerShipDetail:ownershipList){
                    if(leadeDeatil.id!=null)
                    ownerShipDetail.lead__c=leadeDeatil.id;
                    
                    ownerShipRecordList.add(ownerShipDetail);
                }
                if(ownerShipRecordList.size()>0)
                    insert ownerShipRecordList;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   
}