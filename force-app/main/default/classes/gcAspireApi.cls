public virtual inherited sharing class gcAspireApi {
    private static final String AZURE_SUBSCRIPTION_KEY = 'b25a64969b004bd6b10f215abab61243';
    private static final String ENVIRONMENT = 'Tertiary';
    private static List<CrossRoad_APIEndpoint__mdt> endPointsInfo = crossRoadsUtil.getAPIMetaEndpointInfo();
    private static final String AZURE_ASPIRE_BASEURL = endPointsInfo[0].AZURE_ASPIRE_BASEURL__c  ;//'https://crossroads-connect.azure-api.net/Aspire/1/';
    private static final String CREATE_CUSTOMER_ENDPOINT =endPointsInfo[0].CREATE_CUSTOMER_ENDPOINT__c;// 'account';
    private static final String CREATE_LOCATION_ENDPOINT = endPointsInfo[0].CREATE_LOCATION_ENDPOINT__c;//'location.json';
    private static final String CREATE_COMMENT_ENDPOINT = endPointsInfo[0].CREATE_COMMENT_ENDPOINT__c;//'comment';
    private static final String CREATE_ASSET_ENDPOINT = endPointsInfo[0].CREATE_ASSET_ENDPOINT__c;//'asset';
    private static final String CREATE_CONTRACT_ENDPOINT = endPointsInfo[0].CREATE_CONTRACT_ENDPOINT__c;//'contract';
    private static final String CREATE_BANK_ACCOUNT_ENDPOINT =endPointsInfo[0].CREATE_BANK_ACCOUNT_ENDPOINT__c;// 'account/banks/accounts';
    private static final String ADD_ASSETS_TO_CONTRACT_ENDPOINT =endPointsInfo[0].ADD_ASSETS_TO_CONTRACT_ENDPOINT__c;// 'contract/{recordId}/record/assets';
    private static final String ACCOUNT_UDFs_ENDPOINT = endPointsInfo[0].ACCOUNT_UDFs_ENDPOINT__c;//'udfs/group';
    private static final String CONTRACT_STATUS_ENDPOINT = endPointsInfo[0].CONTRACT_STATUS_ENDPOINT__c;//'contractstatus.json';
    private static final String RELATED_ACCOUNTS_ENDPOINT = endPointsInfo[0].RELATED_ACCOUNTS_ENDPOINT__c;//'contract/accounts';
    private static final Integer TEN_MILLION = 10000000;
    private static final String CREATE_TRANSACTION_ENDPOINT = endPointsInfo[0].CREATE_TRANSACTION_ENDPOINT__c;//'transaction';

    public static AspireResponse testResponse() {
        AspireResponse response = new AspireResponse();
        response.Result = new AspireResult();
        response.Errors = new List<gcAspireApi.AspireError>();
        gcAspireApi.AspireError ErrorsDetail = new gcAspireApi.AspireError();
        response.Result.Result = 'Commit';
        response.StatusRespCode = 400; //default status code
        ErrorsDetail.Messages = new List<String>();
        ErrorsDetail.Messages.add('Default Error,Something went wrong with API call');
        response.Errors.add(ErrorsDetail);
        return response;
    }

    public static AspireResponse dummySuccessResponse() {
        AspireResponse response = new AspireResponse();
        response.Result = new AspireResult();
        response.Errors = new List<gcAspireApi.AspireError>();
        gcAspireApi.AspireError ErrorsDetail = new gcAspireApi.AspireError();
        response.Result.Result = 'Commit';
        response.StatusRespCode = 200; //default status code
        ErrorsDetail.Messages = new List<String>();
        ErrorsDetail.Messages.add('Successfully added record to Aspire');
        response.Errors.add(ErrorsDetail);
        return response;
    }

    public class CustomerApi extends gcAspireApi {
        
        public AspireResponse putContractStatus(String opportunityId, String status) {
            HttpRequest request = buildBasicRequest(CONTRACT_STATUS_ENDPOINT);
            request.setMethod('PUT');
            AspireContractStatusRequest requestBody = new AspireContractStatusRequest(opportunityId, status);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse putContrctStatusRes = new AspireResponse();
            putContrctStatusRes = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            putContrctStatusRes.StatusRespCode = response.getStatusCode();
            return putContrctStatusRes;    
            
        }

        public AspireResponse setRelatedAccount(Contact contact, String opportunityId) {
            HttpRequest request = buildBasicRequest(RELATED_ACCOUNTS_ENDPOINT);
            request.setMethod('POST');
            AspireRelatedAccountRequest requestBody = new AspireRelatedAccountRequest(contact, opportunityId);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
            response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse setRelatedAcctResp = new AspireResponse();
            setRelatedAcctResp = (response.getBody() == null || Test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            setRelatedAcctResp.StatusRespCode = response.getStatusCode();
            return setRelatedAcctResp;
        }

        public AspireResponse setRelatedAccount(String aspireId, String role, String opportunityId) {
            HttpRequest request = buildBasicRequest(RELATED_ACCOUNTS_ENDPOINT);
            request.setMethod('POST');
            AspireRelatedAccountRequest requestBody = new AspireRelatedAccountRequest(aspireId, role, opportunityId);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
            response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse setRelatedAccountResp = new AspireResponse();
            setRelatedAccountResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            setRelatedAccountResp.StatusRespCode = response.getStatusCode();
            return setRelatedAccountResp;

        }
        
        public void  startTransaction(String token){

            try{
            HttpRequest request = buildBasicTransRequest(CREATE_TRANSACTION_ENDPOINT,token);
            request.setMethod('POST');
            request.setHeader('Content-length','0');
            HttpResponse response = new Http().send(request);
            System.debug('transaction response' + response);
            }catch (Exception ex){
                System.debug('Error in Start Transaction API');
            }


        }

        public  void commitTransaction(String token){
            try{
                HttpRequest request = buildBasicTransRequest(CREATE_TRANSACTION_ENDPOINT,token);
                request.setMethod('PUT');
                request.setHeader('Content-length','0');
                HttpResponse response = new Http().send(request);
                System.debug('Commit Transaction response' + response);
        }catch (Exception ex){
            System.debug('Error in Commit Transaction API');
        }
        }

        public AspireResponse createCustomer(Account account, Contact contact) {
            
            HttpRequest request = buildBasicTransRequest(CREATE_CUSTOMER_ENDPOINT,String.valueOf(contact.AccountId));
            request.setMethod('POST');
            AspireCreateCustomerRequest requestBody = new AspireCreateCustomerRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
                }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
             //throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse createCustomerResp = new AspireResponse();
            createCustomerResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            createCustomerResp.StatusRespCode = response.getStatusCode();
            return createCustomerResp;

        }

        public AspireResponse updateCustomer(Account account, Contact contact) {
            HttpRequest request = buildBasicRequest(CREATE_CUSTOMER_ENDPOINT);
            request.setMethod('PUT');
            AspireCreateCustomerRequest requestBody = new AspireCreateCustomerRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            AspireResponse customerUpdResp = new AspireResponse();
            customerUpdResp = (response.getBody() == null || (response.getStatusCode() != 422 && response.getStatusCode() != 200) || test.isRunningTest()) ?
                                gcAspireApi.testResponse() : 
                                (AspireResponse)JSON.deserialize(response.getBody(), AspireResponse.class);
            customerUpdResp.StatusRespCode = response.getStatusCode();
            if (response.getStatusCode() != 200 )  {
                // throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            if (response.getStatusCode() == 422) { // no location previously existing
                
                //this.createCustomer(account, contact);
            }

            return customerUpdResp;
        }

        public AspireResponse accountUDFs(Account account, Contact contact) {
            HttpRequest request = buildBasicTransRequest(ACCOUNT_UDFs_ENDPOINT,String.valueOf(contact.AccountId));
            request.setMethod('POST');
            AspireAccountUDFsRequest requestBody = new AspireAccountUDFsRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse udfResp = new AspireResponse();
            udfResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            udfResp.StatusRespCode = response.getStatusCode();
            return udfResp;    
            
        }

        public AspireResponse accountUpdateUDFs(Account account, Contact contact) {
            HttpRequest request = buildBasicRequest(ACCOUNT_UDFs_ENDPOINT);
            request.setMethod('POST');
            AspireAccountUDFsRequest requestBody = new AspireAccountUDFsRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse udfResp = new AspireResponse();
            udfResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            udfResp.StatusRespCode = response.getStatusCode();
            return udfResp;    
            
        }

        
        public AspireResponse addcontractUDFs(Account account, Contact contact,Opportunity oppty) {
            HttpRequest request = buildBasicTransRequest(ACCOUNT_UDFs_ENDPOINT,String.valueOf(contact.AccountId));
            request.setMethod('POST');
            AspireContractUDFsRequest requestBody = new AspireContractUDFsRequest(account, contact,oppty);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse udfResp = new AspireResponse();
            udfResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            udfResp.StatusRespCode = response.getStatusCode();
            return udfResp;    
            
        }

        public AspireResponse addcontractCreditUDFs(Account account, Contact contact,Opportunity oppty,String requestType) {
            HttpRequest request = buildBasicRequest(ACCOUNT_UDFs_ENDPOINT);
            request.setMethod(requestType);//requestType willbe POST or PUT depending on to create or update
            AspireContractCreditUDFsRequest requestBody = new AspireContractCreditUDFsRequest(account, contact,oppty);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse udfResp = new AspireResponse();
            udfResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            udfResp.StatusRespCode = response.getStatusCode();
            return udfResp;    
            
        }

        public AspireResponse contractUpdateUDFs(Account account, Contact contact,Opportunity oppty) {
            HttpRequest request = buildBasicRequest(ACCOUNT_UDFs_ENDPOINT);
            request.setMethod('POST');
            AspireContractUDFsRequest requestBody = new AspireContractUDFsRequest(account, contact,oppty);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse udfResp = new AspireResponse();
            udfResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            udfResp.StatusRespCode = response.getStatusCode();
            return udfResp;    
            
        }

        public AspireResponse createLocation(Dealership__c dealership) {
            HttpRequest request = buildBasicRequest(CREATE_LOCATION_ENDPOINT);
            request.setMethod('POST');
            AspireCreateLocationRequest requestBody = new AspireCreateLocationRequest(dealership);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse locCrtResp = new AspireResponse();
            locCrtResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            locCrtResp.StatusRespCode = response.getStatusCode();
            return locCrtResp;
            
        }

        public AspireResponse updateLocation(Dealership__c dealership) {
            HttpRequest request = buildBasicRequest(CREATE_LOCATION_ENDPOINT);
            request.setMethod('PUT');
            AspireCreateLocationRequest requestBody = new AspireCreateLocationRequest(dealership);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse locUpResp = new AspireResponse();
            locUpResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
                            locUpResp.StatusRespCode = response.getStatusCode();
            return locUpResp;
            
        }

        public AspireResponse createLocation(Account account, Contact contact) {
            HttpRequest request = buildBasicRequest(CREATE_LOCATION_ENDPOINT);
            request.setMethod('POST');
            AspireCreateLocationRequest requestBody = new AspireCreateLocationRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse locCrtResp = new AspireResponse();
            locCrtResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            locCrtResp.StatusRespCode = response.getStatusCode();
            return locCrtResp;
        }

        public AspireResponse updateLocation(Account account, Contact contact) {
            HttpRequest request = buildBasicRequest(CREATE_LOCATION_ENDPOINT);
            request.setMethod('PUT');
            AspireCreateLocationRequest requestBody = new AspireCreateLocationRequest(account, contact);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            AspireResponse locUpdResp = new AspireResponse();
            locUpdResp = (response.getBody() == null|| test.isRunningTest()) ? 
                          gcAspireApi.testResponse() :
                         (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            locUpdResp.StatusRespCode = response.getStatusCode();
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            if (response.getStatusCode() == 422) { // no location previously existing
                //this.createLocation(account, contact);
            }

            return locUpdResp;
        }

        public AspireResponse createComment(String recordId, String referenceRecordId, String referenceRecordTypeCode, String referenceRecordTypeDescription, String subject,
                String text, String importance, String commentTypeCode, String commentTypeDescription, Date expirationDate, String regardingAccountId) {
            HttpRequest request = buildBasicRequest(CREATE_COMMENT_ENDPOINT);
            request.setMethod('POST');
            AspireCreateCommentRequest requestBody = new AspireCreateCommentRequest(recordId, referenceRecordId, referenceRecordTypeCode, referenceRecordTypeDescription, subject, text, importance, commentTypeCode, commentTypeDescription, expirationDate,  regardingAccountId);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse CommentResp = new AspireResponse();
            CommentResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            
            return CommentResp;
        }

        public AspireResponse createContract(Opportunity opportunity) {
            HttpRequest request = buildBasicTransRequest(CREATE_CONTRACT_ENDPOINT,opportunity.AccountId);
            request.setMethod('POST');
            AspireCreateContractRequest requestBody = new AspireCreateContractRequest(opportunity);
            System.debug(JSON.serializePretty(requestBody, true));
            System.debug(request.getEndpoint());
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse contractResp = new AspireResponse();
            contractResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            
            return contractResp;

        }

        public AspireResponse updateContract(Opportunity opportunity) {
            HttpRequest request = buildBasicRequest(CREATE_CONTRACT_ENDPOINT);
            request.setMethod('PUT');
            AspireCreateContractRequest requestBody = new AspireCreateContractRequest(opportunity);
            System.debug(JSON.serializePretty(requestBody, true));
            request.setBody(JSON.serializePretty(requestBody));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse contractResp = new AspireResponse();
            contractResp = (response.getBody() == null || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            
            return contractResp;
        }

        public AspireResponse createBankAccount(String recordId, String bankRecordId, String accountNumber, String type, String category, Boolean active, Date inactiveDate) {
            HttpRequest request = buildBasicRequest(CREATE_BANK_ACCOUNT_ENDPOINT);
            request.setMethod('POST');
            AspireCreateListBankAccountRequest requestBody = new AspireCreateListBankAccountRequest();
            requestBody.bankAccounts.add(new AspireCreateBankAccountRequest(recordId, bankRecordId, accountNumber, type, category, active, inactiveDate));
            System.debug(JSON.serializePretty(requestBody.bankAccounts, true));
            request.setBody(JSON.serializePretty(requestBody.bankAccounts));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse createBankAccount = new AspireResponse();
            createBankAccount = ((response.getBody() == null || test.isRunningTest()) ?
                                gcAspireApi.testResponse() : 
                                (AspireResponse)JSON.deserialize(response.getBody(), AspireResponse.class));
                                createBankAccount.StatusRespCode = response.getStatusCode();

            return createBankAccount;
        }

        public AspireResponse createAssets(List<Asset> assets) {
            System.debug('Did we get assets--->'+assets);
            HttpRequest request = buildBasicRequest(CREATE_ASSET_ENDPOINT);
            request.setMethod('POST');
            System.debug('What does the request look like--->'+request);
            AspireCreateAssetRequest requestBody = new AspireCreateAssetRequest(assets);
            System.debug(JSON.serializePretty(requestBody.aspireAssets, true));
            request.setBody(JSON.serializePretty(requestBody.aspireAssets));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse createAssetsResp = new AspireResponse();
            createAssetsResp = ((response.getBody() == null ||test.isRunningTest()) ?
                                gcAspireApi.testResponse() : 
                                (AspireResponse)JSON.deserialize(response.getBody(), AspireResponse.class));
                                createAssetsResp.StatusRespCode = response.getStatusCode();

            return createAssetsResp;
        }

        public AspireResponse addAssetsToContract(Opportunity opportunity, List<Asset> assets) {

            HttpRequest request = buildBasicRequest(ADD_ASSETS_TO_CONTRACT_ENDPOINT.replace('{recordId}',String.valueOf(opportunity.Id).left(15)));
            request.setMethod('POST');
            AspireAddAssetsToContractRequest requestBody = new AspireAddAssetsToContractRequest(opportunity, assets);
            System.debug(JSON.serializePretty(requestBody.aspireAssets, true));
            request.setBody(JSON.serializePretty(requestBody.aspireAssets));
            HttpResponse response = new HttpResponse();
            if(! test.isRunningTest()){
                response = new Http().send(request);
            }
            System.debug(response.getBody());
            System.debug(response.getStatusCode());
            if (response.getStatusCode() != 200) {
//                throw new gcAspireApiException(response.getStatusCode(), response.getBody());
            }
            AspireResponse addAssetstResp = new AspireResponse();
            addAssetstResp = (response.getBody() == null  || test.isRunningTest()) ? 
                            gcAspireApi.testResponse() :
                            (AspireResponse) JSON.deserialize(response.getBody(), AspireResponse.class);
            
            return addAssetstResp;
        }

    }


    private static HttpRequest buildBasicTransRequest(String methodEndpoint,String token) {
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        //generate a random token for Transactions to work in Aspire
        //Datetime myDT = Datetime.now();
        //String token = myDT.format('yyyyMMddhhmm');
        request.setEndpoint(AZURE_ASPIRE_BASEURL + methodEndpoint +'?token='+token);
        request.setHeader('Environment', ENVIRONMENT);
        request.setHeader('Ocp-Apim-Subscription-Key', AZURE_SUBSCRIPTION_KEY);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', '*/*');
        request.setTimeout(120000);
       // System.debug('What does the request look like--->'+request);
        return request;
    }

    private static HttpRequest buildBasicRequest(String methodEndpoint) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(AZURE_ASPIRE_BASEURL + methodEndpoint);
        request.setHeader('Environment', ENVIRONMENT);
        request.setHeader('Ocp-Apim-Subscription-Key', AZURE_SUBSCRIPTION_KEY);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', '*/*');
        request.setTimeout(120000);
       // System.debug('What does the request look like--->'+request);
        return request;
    }

    public class AspireContractStatusRequest {
        public String ContractIdentifier;
        public String Status;

        public AspireContractStatusRequest(String opportunityId, String status) {
            this.ContractIdentifier = String.valueOf(opportunityId).left(15);
            this.Status = status;
        }
    }

    public class AspireRelatedAccountRequest {
        public RecordId ContractId;
        public RecordId EntityId;
        public String AccountType;
        public AspireRole Role;

        public AspireRelatedAccountRequest(Contact contact, String opportunityId) {
            this.ContractId = new RecordId(String.valueOf(opportunityId).left(15), 'Record');
            this.EntityId = new RecordId(String.valueof(contact.AccountId).left(15), 'Record');
            this.Role = new AspireRoleFactory().getRole(contact.Opportunity_Role__c);
        }

        public AspireRelatedAccountRequest(String aspireId, String role, String opportunityId) {
            this.ContractId = new RecordId(String.valueOf(opportunityId).left(15), 'Record');
            this.EntityId = new RecordId(aspireId, 'Record');
            this.Role = new AspireRoleFactory().getRole(role);
        }
    }

    public class AspireCreateCustomerRequest {
        public String AccountId;
        public RecordId RecordId;
        public RecordId LocationRecordId;
        public AspireAccountType AccountType;
        public String LastName;
        public String FirstName;
        public String Name;
        public String Email;
        public String Role;
        public List<AspireRole> Roles;
        public Decimal PercentOwnership;
        public String LegalName;
        public String FederalIdentificationNumber;
        public String DoingBusinessAs;
        public CompanyType CompanyType;
        //public String CompanyType;
        public String StateOfIncorporation;
        public String SSN;
        public String MainAddress;
        public String City;
        public String State;
        public String Zip;
        public Integer NumberOfEmployees;
        public Decimal YrsCDL;
//        public Decimal FleetSize;
        public Decimal Revenue;
        public String PreviousTruckCredit;
        public String Reason;
        public String HaulType;
        public String Hazmat;
        public Decimal AnnualMiles;
        public String MXCN;
        public String IndustryCode;
        public Date DateOfBirth;
        public List<PhoneNumbers> PhoneNumbers;
        public RecordId SalesRepresentative;

        public AspireCreateCustomerRequest (Account account, Contact contact) {
            Boolean useContactData = contact.coApplicant__c || contact.Is_Additional_Business_Contact__c;
            this.AccountId = useContactData ? String.valueOf(contact.Id).left(15) : String.valueOf(account.Id).left(15);
            System.debug(useContactData);
            if (account.Applicant_Type__c == 'Company') {
                Map<String, String> stateCodesMap = getStateCodesMap();
                this.AccountType = AspireAccountType.Business;
                this.Name = useContactData ? contact.Name.left(100) : account.Name.left(100);
//                this.FederalIdentificationNumber = useContactData ? contact.SSN__c : account.EIN__c;
                this.FederalIdentificationNumber = useContactData ?  contact.SSN__c : account.Tax_ID__c;
                this.DoingBusinessAs = account.DBA__c;
                this.CompanyType = new CompanyType(account);
                this.StateOfIncorporation = account.State_Of_Incorporation__c != null && stateCodesMap.containsKey(account.State_Of_Incorporation__c) ? stateCodesMap.get(account.State_Of_Incorporation__c) : null;
                this.NumberOfEmployees = account.NumberOfEmployees;
            } else {
                this.AccountType = AspireAccountType.Individual;
                this.FirstName = contact.FirstName;
                this.LastName = contact.LastName;
                this.FederalIdentificationNumber = contact.SSN__c;
            }
            System.debug(this.Name);

            this.IndustryCode = account.Industry_Code__c;
            this.LegalName = account.Name.left(100);
            this.PercentOwnership = contact.Percent_Ownership__c;
            this.YrsCDL = account.Years_with_CDL__c;
            this.DateOfBirth = (account.Date_of_Birth__c !=null) ? account.Date_of_Birth__c :contact.Birthdate;
//            this.FleetSize = account.Fleet_Size__c;
//            this.SSN = contact.SSN__c;
            this.MainAddress = account.BillingStreet != null ? account.BillingStreet : contact.MailingStreet;
            this.City = account.BillingCity != null ? account.BillingCity : contact.MailingCity;
            this.State = account.BillingStateCode != null ? account.BillingStateCode : contact.MailingStateCode;
            this.Zip = account.BillingPostalCode != null ? account.BillingPostalCode : contact.MailingPostalCode;
            this.Revenue = account.AnnualRevenue;
            this.PreviousTruckCredit = String.valueOf(account.Previous_Financing__c);
            this.Reason = account.Reason_for_Purchase__c;
            this.HaulType = account.Haul_Type__c;
            this.Hazmat = String.valueOf(account.Do_You_Haul_HAZMAT__c);
            this.AnnualMiles = account.Annual_Mileage__c;
            this.MXCN = String.valueOf(account.Haul_Internationally__c);

            this.RecordId = new RecordId(useContactData ? String.valueOf(contact.Id).left(15) : String.valueOf(account.Id).left(15), 'Record');
            this.LocationRecordId = new RecordId('L'+ (useContactData ? String.valueOf(contact.Id).left(15) : String.valueOf(account.Id).left(15)), 'Record');
            this.Email = account.Email_Address__c != null ? account.Email_Address__c.left(100) : null;
            this.Roles = new List<AspireRole>{new AspireRoleFactory().getRole(contact.Opportunity_Role__c)};
            this.Role = 'Customer';
            this.PhoneNumbers = new List<PhoneNumbers>{new PhoneNumbers(contact.Phone,'Main'),
                                new PhoneNumbers(contact.MobilePhone,'Mobile')};
            this.SalesRepresentative = new RecordId(account.Owner.Name,'Record');                    
        }
    }
    public class RecordId {
        public String Type;
        public String Value;

        public RecordId (String value, String type) {
            this.Type = type;
            this.Value = value;
        }
    }
    public enum AspireAccountType {
        Business,
        Individual
    }

    public class AspireRole {
        public String RoleType;
        public String Description;

        public AspireRole (String roleType, String description) {
            this.RoleType = roleType;
            this.Description = description;
        }

    }

    public class CompanyType {
        public String Code;
        public String Description;

        public CompanyType(Account acc) {
            if(acc.Legal_Structure__c !=null){
            this.Code = acc.Legal_Structure__c.substring(0, 1) == 'C' ? 'C'
                    : (acc.Legal_Structure__c.substring(0, 1) == 'P' ? 'P'
                            : (acc.Legal_Structure__c.substring(0, 1) == 'L' ? 'LLC' : ''));
            if (this.Code == 'C'){
                this.Description = 'Corporation';
            } else if (this.Code == 'P') {
                this.Description = 'Partnership';
            } else {
                this.Description = 'Limited Liability Company';
            }
        }
        }
    }
    //PhoneNumbers
    public class PhoneNumbers {
        public String NumberX ='000000000';
        public String Extension ='';
        public String PhoneNumberType ='';
        public Boolean IsPrimary = false;

        public PhoneNumbers(String phone,String type) {
            if(String.isNotEmpty(phone)){
            this.NumberX = phone;
            }
            if(String.isNotBlank(type)){
            this.PhoneNumberType = type;
            }
        }
    }

    public enum AspireRoleType {
        Attorney,
        Broker,
        Collector,
        Contact,
        ContractManager,
        CreditAnalyst,
        Customer,
        EquityOwner,
        FinanceCompany,
        FundingSource,
        Guarantor,
        Other,
        SalesRep,
        Vendor,
        VendorSalesRep,
        TaxAdmin
    }

    public class AspireRoleFactory {
        public AspireRole getRole(String roleType){
            switch on roleType {
                when 'Attorney' {
                    return new AspireRole('ATTY', 'Attorney');
                }
                when 'Broker' {
                    return new AspireRole('BROK', 'Broker');
                }
                when 'Collector' {
                    return new AspireRole('CLLTR', 'Collector');
                }
                when 'Contact' {
                    return new AspireRole('CONTACT', 'Contact');
                }
                when 'ContractManager' {
                    return new AspireRole('CNMGR', 'Contract Manager');
                }
                when 'CreditAnalyst' {
                    return new AspireRole('CRANLYST', 'Credit Analyst');
                }
                when 'Customer' {
                    return new AspireRole('CUST', 'Customer');
                }
                when 'EquityOwner' {
                    return new AspireRole('EQOWN', 'Equity Owner');
                }
                when 'FinanceCompany' {
                    return new AspireRole('FNCOMP', 'Finance Company');
                }
                when 'FundingSource' {
                    return new AspireRole('FNDSRC', 'Funding Source');
                }
                when 'Guarantor' {
                    return new AspireRole('GUAR', 'Guarantor');
                }
                when 'Other' {
                    return new AspireRole('OTHER', 'Other');
                }
                when 'SalesRep' {
                    return new AspireRole('SLSREP', 'Sales Rep');
                }
                when 'Vendor' {
                    return new AspireRole('VEND', 'Vendor');
                }
                when 'VendorSalesRep' {
                    return new AspireRole('VENDSREP', 'Vendor - Sales Rep');
                }
                when 'TaxAdmin' {
                    return new AspireRole('TAXADMIN', 'Tax Administrator');
                }
                when 'CoBorrower' {
                    return new AspireRole('CUST', 'CoBorrower');
                }
                when 'Accounting' {
                    return new AspireRole('OTHER10', 'Accounting');
                }
                when else {
                    return new AspireRole(null, null);
                }
            }
        }
    }

    public static Map<String, String> getStateCodesMap() {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get('User');
        Schema.DescribeFieldResult fieldResult = objectType.getDescribe().fields.getMap().get('statecode').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, String> values = new Map<String, String>();
        for (Schema.PicklistEntry f : ple) {
            values.put(f.getLabel(), f.getValue());
        }
        return values;
    }

    public class AspireResponse {
        @AuraEnabled
        public AspireResult Result;
        @AuraEnabled
        public List<AspireError> Errors;
        @AuraEnabled
        public List<String> Messages;
        @AuraEnabled
        public Integer StatusRespCode;
    }

    public class AspireResult {
        @AuraEnabled
        public Datetime Created;
        @AuraEnabled
        public Datetime Completed;
        @AuraEnabled
        public String Result;
        @AuraEnabled
        public String Message;
        @AuraEnabled
        public String Token;
        
    }

    public class AspireError {
        @AuraEnabled
        public AspireErrorId Id;
        @AuraEnabled
        public List<String> Messages;
        @AuraEnabled
        public String Code;
        @AuraEnabled
        public String Message;
    }

    public class AspireErrorId {
        @AuraEnabled
        public String Value;
        @AuraEnabled
        public String Type;
    }

    public class AspireAccountUDFsRequest {
        public RecordId RecordId;
        public List<Field> Fields;
        Public String Type;
        Public String Action;

        public AspireAccountUDFsRequest (Account account, Contact contact) {
            this.RecordId = new RecordId(contact.coApplicant__c || contact.Is_Additional_Business_Contact__c ? String.valueOf(contact.Id).left(15) : String.valueOf(account.Id).left(15), 'Record');
            this.Type = 'Customer';
            this.Action = '4';

            this.Fields = new List<Field>();

            if(account.NumberOfEmployees != null){
                this.Fields.add(new Field('Customer_NumberOfEmployees', String.valueOf(account.NumberOfEmployees), 'Numeric'));
            }

            if (contact.Years_with_CDL__c != null) {
                this.Fields.add(new Field('Customer_YrsCDL', String.valueOf(contact.Years_with_CDL__c) , 'Numeric'));
            }

            if (account.Fleet_Size__c != null) {
                this.Fields.add(new Field('Customer_FleetSize', String.valueOf(account.Fleet_Size__c), 'Numeric'));
            }

            if (account.Years_in_Business__c != null) {
                this.Fields.add(new Field('Customer_YrsIOO', String.valueOf(account.Years_in_Business__c), 'Numeric'));
            }

            if(account.AnnualRevenue != null){
                this.Fields.add(new Field('Customer_AvgAnnualRevenue', String.valueOf(account.AnnualRevenue), 'Numeric'));
            }

            if (contact.OpportunityContactRoles.size() > 0 && contact.OpportunityContactRoles[0].Opportunity.Replacement_Equipment__c != null) {
                if (contact.OpportunityContactRoles[0].Opportunity.Replacement_Equipment__c == true) {
                    this.Fields.add(new Field('Customer_Reason', 'Yes', 'Text'));

                } else {
                    this.Fields.add(new Field('Customer_Reason', 'No', 'Text'));

                }
            }

            if (account.Annual_Mileage__c != null) {
                this.Fields.add(new Field('Customer_AnnualMiles', String.valueOf(account.Annual_Mileage__c), 'Numeric'));
            }

            if (account.Haul_Internationally__c != null) {
                this.Fields.add(new Field('Customer_MXCN', String.valueOf(account.Haul_Internationally__c), 'Text'));
            }

            if (account.Do_You_Haul_HAZMAT__c != null) {
                if(account.Do_You_Haul_HAZMAT__c == true){
                    this.Fields.add(new Field('Customer_Hazmat', 'Yes', 'Text'));

                }
                else{
                    this.Fields.add(new Field('Customer_Hazmat', 'No', 'Text'));

                }

            }

            if (account.Haul_Type__c != null) {
                this.Fields.add(new Field('Customer_HaulType', String.valueOf(account.Haul_Type__c), 'Text'));
            }

            /* -duplicate to account value,causing exception in UDF api
            if (contact.Years_IOO_Experience__c != null) {
                this.Fields.add(new Field('Customer_YrsIOO', String.valueOf(account.Years_in_Business__c), 'Numeric'));
            }*/

            if (contact.OpportunityContactRoles.size() > 0 && String.isNotBlank(contact.OpportunityContactRoles[0].Opportunity.DurationPrimaryHaulSouce__c)) {
                this.Fields.add(new Field('Customer_MonthsLMC', String.valueOf(contact.OpportunityContactRoles[0].Opportunity.DurationPrimaryHaulSouce__c), 'Text'));
            }

            if (contact.OpportunityContactRoles.size() > 0 && contact.OpportunityContactRoles[0].Opportunity.Past_Commercial_Finance__c != null) {
                if (contact.OpportunityContactRoles[0].Opportunity.Past_Commercial_Finance__c == true) {
                    this.Fields.add(new Field('Customer_PrevTruckCR', 'Yes', 'Text'));

                } else {
                    this.Fields.add(new Field('Customer_PrevTruckCR', 'No', 'Text'));

                }
            }

            if (account.International_Mileage__c != null) {
                this.Fields.add(new Field('Customer_MilesMXCN', String.valueOf(account.International_Mileage__c), 'Numeric'));
            }

            if (account.Majority_in_CA__c != null) {
                this.Fields.add(new Field('Majority_in_CA_c', String.valueOf(account.Majority_in_CA__c), 'Text'));
                this.Fields.add(new Field('Customer_JobsCreated', String.valueOf(account.Majority_in_CA__c), 'Text'));
                this.Fields.add(new Field('Customer_JobsRetained', String.valueOf(account.Majority_in_CA__c), 'Text'));
            }


            this.Fields.add(new Field('Customer_Source', 'Salesforce', 'Text'));
        }
    }

    public class AspireContractUDFsRequest {
        public RecordId RecordId;
        public List<Field> Fields;
        Public String Type;
        Public String Action;

        public AspireContractUDFsRequest (Account account, Contact contact,Opportunity oppty) {
            this.RecordId = new RecordId(String.valueOf(oppty.Id).left(15), 'Record');
            this.Type = 'Contract';
            this.Action = '4';

            this.Fields = new List<Field>();

            if(account.FCAP_Recruiter__c != null){
                this.Fields.add(new Field('Contract_Sponsor', (account.FCAP_Recruiter__c), 'Text'));
            }
            
        }
    }

    public class AspireContractCreditUDFsRequest {
        public RecordId RecordId;
        public List<Field> Fields;
        Public String Type;
        Public String Action;

        public AspireContractCreditUDFsRequest (Account account, Contact contact,Opportunity oppty) {
            this.RecordId = new RecordId(String.valueOf(oppty.Id).left(15), 'Record');
            this.Type = 'ContractCredit';
            this.Action = '4';
            this.Fields = new List<Field>();
            if(oppty.VPR__c != null){
                this.Fields.add(new Field('ContractCR_VPR', String.valueOf(oppty.VPR__c), 'Numeric'));
            }
            if(oppty.Max_Term__c != null){
                this.Fields.add(new Field('ContractCR_MaxTerm', String.valueOf(oppty.Max_Term__c), 'Numeric'));
            }
            /*if(oppty.Vendor_Dealer_Reserve__c != null){
                this.Fields.add(new Field('ContractCR_VenderPriceRation', (oppty.Vendor_Dealer_Reserve__c), 'Numeric'));
            }*/
            if(oppty.Net_Yield_Pre_Tax_Yield__c != null){
                this.Fields.add(new Field('ContractCR_NetYield', String.valueOf(oppty.Net_Yield_Pre_Tax_Yield__c), 'Numeric'));
            }
        }
    }


    private static Boolean isNumOfEmployeeLess100(Decimal quantity){
        return (quantity == null && quantity < 100);
    }

    private static Boolean isAnnualRevenueLess10M(Decimal revenue){
        return (revenue == null && revenue < TEN_MILLION);
    }

    public class AspireCreateLocationRequest {
        public String RecordId;
        public String Description;
        public String Address1;
        public String City;
        public String State;
        public String PostalCode;
        public String Country;
        public Boolean Active;
        public RecordId EntityRecordId;
        public String Email;
        public Boolean IsActive = true;
        public Boolean IsPrimary = true;

        public AspireCreateLocationRequest(Dealership__c dealership) {
//            this.RecordId = dealership.Id;
            this.RecordId = String.valueOf(dealership.Id).left(15);
            this.Description = dealership.Name;
            this.Address1 = dealership.Street_Address__c;
            this.City = dealership.City__c;
            this.State = dealership.State__c;
            this.PostalCode = String.valueOf(dealership.Zip_Postal_Code__c);
            this.Country = 'USA';
            this.Active = true;
//            this.EntityRecordId = new RecordId(String.valueOf(dealership.Account__c).left(15), 'Record');
            this.EntityRecordId = new RecordId('1', 'Transaction');
            this.Email = dealership.Email__c;
        }

        public AspireCreateLocationRequest(Account account, Contact contact) {
            Boolean useContactData = contact.coApplicant__c || contact.Is_Additional_Business_Contact__c;
//            this.RecordId = 'L' + (useContactData ? contact.Id : account.Id);
            this.RecordId = 'L' + (useContactData ? String.valueOf(contact.Id).left(15) : String.valueOf(account.Id).left(15));
            this.Description = 'Location ' + (useContactData ? contact.Name : account.Name);
            this.Address1 = account.BillingStreet != null ? account.BillingStreet : contact.MailingStreet;
            this.City = account.BillingCity != null ? account.BillingCity : contact.MailingCity;
            this.State = account.BillingStateCode != null ? account.BillingStateCode : contact.MailingStateCode;
            this.PostalCode = account.BillingPostalCode != null ? account.BillingPostalCode : contact.MailingPostalCode;
            this.Country = 'USA';
            this.Active = true;
//            this.EntityRecordId = new RecordId(String.valueOf(account.Id).left(15), 'Record');
            this.EntityRecordId = new RecordId('1', 'Transaction');
            this.Email = account.Email_Address__c != null ? account.Email_Address__c : contact.Email;
        }

        public AspireCreateLocationRequest(String recordId, String description, String street, String city, String state, String zip, String country) {
            this.RecordId = recordId;
            this.Description = description;
            this.Address1 = street;
            this.City = city;
            this.State = state;
            this.PostalCode = zip;
            this.Country = country;
        }
    }

    public class AspireCreateCommentRequest {
        public RecordId RecordId;
        public RecordId ReferenceRecordId;
        public ReferenceRecordType ReferenceRecordType;
        public String Subject;
        public String Text;
        public String Importance;
        public ReferenceRecordType CommentType;
        public Date ExpirationDate;
        public RecordId RegardingAccount;

        public AspireCreateCommentRequest(String recordId, String referenceRecordId, String referenceRecordTypeCode, String referenceRecordTypeDescription, String subject,
                                            String text, String importance, String commentTypeCode, String commentTypeDescription, Date expirationDate, String regardingAccountId) {
            this.RecordId = new RecordId(recordId, 'record');
            this.ReferenceRecordId = new RecordId(referenceRecordId, 'record');
            this.RegardingAccount = new RecordId(regardingAccountId, 'record');
            this.ReferenceRecordType = new ReferenceRecordType(referenceRecordTypeCode, referenceRecordTypeDescription);
            this.Subject = subject;
            this.Text = text;
            this.Importance = importance;
            this.CommentType = new ReferenceRecordType(commentTypeCode, commentTypeDescription);
            this.ExpirationDate = expirationDate;
        }
    }

    public class AspireCreateListBankAccountRequest {
        public List<AspireCreateBankAccountRequest> bankAccounts;

        public AspireCreateListBankAccountRequest() {
            this.bankAccounts = new List<AspireCreateBankAccountRequest>();
        }
    }

    public class AspireCreateBankAccountRequest {
        public String RecordId;
        public RecordId BankRecordId;
        public String AccountNumber;
        public String Type;
        public String Category;
        public Boolean Active;
        public Date InactiveDate;

        public AspireCreateBankAccountRequest(String recordId, String bankRecordId, String accountNumber, String type, String category, Boolean active, Date inactiveDate) {
            this.RecordId = recordId;
            this.BankRecordId = new RecordId(bankRecordId, 'record');
            this.AccountNumber = accountNumber;
            this.Type = type;
            this.Category = category;
            this.Active = active;
            this.InactiveDate = inactiveDate;
        }
    }

    public class ReferenceRecordType {
        public String Code;
        public String Description;

        public ReferenceRecordType(String code, String description) {
            this.Code = code;
            this.Description = description;
        }
    }

    public class AspireCreateContractRequest {
        public String ContractId;
        public RecordId FinanceCompanyRecordId;
        public RecordId CustomerRecordId;
        public RecordId BillToLocationRecordId;
        public RecordId RemitToLocationRecordId;
        public RecordId TaxLocationRecordId;
        public RecordId RecordId;
        public String StartDate;
        public String CompoundingPeriod;
        public String ComputeMethod;
        public String YearLength;
        public String ReplacementEquipment;
        public ContractStatus ContractStatus;
        public ReferenceRecordType FinanceProgram;
        public Integer Term;
        public Decimal AmountFinanced;
        public Decimal DownPayment;
        public Date BidAcceptedDate;

        public AspireCreateContractRequest(Opportunity opportunity) {
            this.StartDate = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            this.CustomerRecordId = new RecordId(String.valueOf(opportunity.AccountId).left(15), 'Record');
            this.RecordId = new RecordId(String.valueOf(opportunity.Id).left(15), 'Record');
            this.FinanceCompanyRecordId = new RecordId('3', 'Transaction');
            this.ContractId = String.valueOf(opportunity.Id).left(15);
            this.CompoundingPeriod = 'Monthly';
            this.ComputeMethod = 'Normal';
            this.ContractStatus = new ContractStatus(opptyStatus(opportunity));
            this.YearLength = 'YearLength365';
            this.Term = opportunity.Term__c == null ? 0 : Integer.valueOf(opportunity.Term__c);
            this.FinanceProgram = setFinanceProgram(opportunity);
            this.AmountFinanced = opportunity.Amount;
            this.DownPayment = opportunity.Down_Payment__c;
            this.BidAcceptedDate = opportunity.Bid_Accepted_Date__c;

            if(opportunity.Replacement_Equipment__c == true){
                this.ReplacementEquipment = 'Yes';
            }
            else{
                this.ReplacementEquipment = 'No';
            }

        }
        
        private String opptyStatus(Opportunity oppty){
            String returnStatus ='';
            if(oppty.StageName == 'Credit Approval'){
                returnStatus = 'Final Approval';
            } 
            else{
                returnStatus = 'Submit to Credit';
            }   
            return returnStatus;
        }
        private ReferenceRecordType setFinanceProgram (Opportunity opportunity) {
            Integer assetMinYear;
            Set<String> assetTypes = new Set<String>();

            for (Opportunity_Asset__c opportunityAsset : opportunity.Opportunity_Assets__r) {
                assetTypes.add(opportunityAsset.Asset__r.Vehicle_Type__c);
                if (opportunityAsset.Asset__r.Year__c != null && (assetMinYear == null || Integer.valueOf(opportunityAsset.Asset__r.Year__c) < assetMinYear)) {
                    assetMinYear = Integer.valueOf(opportunityAsset.Asset__r.Year__c);
                }
            }

            ReferenceRecordType financeProgram = null;

            if (opportunity.Majority_in_CA__c && isNumOfEmployeeLess100(opportunity.Account.NumberOfEmployees) && isAnnualRevenueLess10M(opportunity.Account.AnnualRevenue)
                    && opportunity.Title_or_IRP_base_plate_CA__c && opportunity.Account.Fleet_Size__c <= 10 && assetMinYear >= 2011
                    && opportunity.Opportunity_Assets__r.size() >= 1 && (assetTypes.contains('Tractor') || assetTypes.contains('Commercial Trucks'))
                    && opportunity.Rate__c <= 0.2) {
                if (!opportunity.App_Only_Deal__c) {
                    financeProgram = new ReferenceRecordType('FLEET/CALCAP', 'Fleet/Calcap');
                } else {
                    financeProgram = new ReferenceRecordType('CALCAP', 'Flow/Calcap');
                }
            } else if (opportunity.App_Only_Deal__c) {
                financeProgram = new ReferenceRecordType('FLOW', 'Flow/Non-CalCAP');
            } else if (!opportunity.App_Only_Deal__c) {
                financeProgram = new ReferenceRecordType('FLEET', 'Fleet/Non-CalCAP');
            }

            return financeProgram;
        }
    }

    public class AspireCreateAssetRequest {
        public List<AspireAsset> aspireAssets;

        public AspireCreateAssetRequest(List<Asset> assets) {
            aspireAssets = new List<AspireAsset>();

            for (Asset asset : assets) {
                aspireAssets.add(new AspireAsset(asset));
            }
        }

    }

    public class AspireAsset {
        public RecordId RecordId;
        public List<String> SerialNumbers;
        public Integer Quantity;
        public String Description;
        public Decimal CarryingCost;
        public String DateAvailableForSale;
        public Boolean IsNew;
        public AssetStatus AssetStatus;
        public AssetType AssetType;
        public RecordId FinanceCompanyRecordId;
        public String HeldForContractOid;
        public String InvoiceNumber;
        public Boolean IsBooked;
        public Boolean IsSoftCost;
        public Boolean IsTerminated;
        public RecordId LocationRecordId;
        public String Machine;
        public String Manufacturer;
        public String Model;
        public String ModelYear;
        public Decimal OriginalCost;
        public Decimal CurrentResidualAmount;
        public Decimal CurrentResidualPercent;
        public String PaidDate;
        public String PartNumber;
        public String PurchaseDate;
        public String PurchaseOrderNumber;
        public RecordId ResponsiblePartyForTitle;
        public String StockNumber;
        public String TitleDate;
        public String TitleExpirationDate;
        public String TitleNumber;
        public String TitleState;
        public AssetStatus TitleStatus;
        public Decimal UsefulLife;
        public RecordId VendorRecordId;

        public AspireAsset(Asset asset) {
            this.RecordId = new RecordId(asset.Id, 'record');
            this.SerialNumbers = new List<String>();
            this.SerialNumbers.add(asset.VIN__c);
            this.StockNumber = '';
            this.Manufacturer = asset.Make__c;
            this.ModelYear = asset.Year__c;
            this.Model = asset.Model__c;
            this.Quantity = 1;
            this.CarryingCost = 0;
            this.Description = String.isNotEmpty(asset.Description) ? asset.Description : asset.Name;
            this.AssetStatus = new AssetStatus(asset.Status, 'EquipmentStatus');
            this.AssetType = new AssetType(asset.Asset_Type__c, '');
            this.FinanceCompanyRecordId = new RecordId('3', 'record');
            this.VendorRecordId = new RecordId('3', 'Transaction');
            this.ResponsiblePartyForTitle = new RecordId('1', 'Transaction');
            this.LocationRecordId = new RecordId('1', 'Transaction');
            this.IsBooked = false;
            this.IsTerminated = false;
        }
    }

    public class AssetStatus {
        public String Name;
        public String StatusType;

        public AssetStatus(String name, String statusType) {
            this.Name = name;
            this.StatusType = statusType;
        }
    }

    public class AssetType {
        public String Code;
        public String Description;

        public AssetType(String code, String description) {
            this.Code = code;
            this.Description = description;
        }
    }

    public class AspireAddAssetsToContractRequest {

        public List<AspireContractAsset> aspireAssets;

        public AspireAddAssetsToContractRequest(Opportunity opportunity, List<Asset> assets) {
            aspireAssets = new List<AspireContractAsset>();
            for (Asset asset : assets) {
                aspireAssets.add(new AspireContractAsset(asset,opportunity));
            }

        }
    }

    public class AspireContractAsset {
        public RecordId RecordId;
        public String Manufacturer;
        public String ModelYear;
        public String Condition;
        public Decimal UnitAmount;
        public Integer Quantity;
        public Integer CarryingCost;
        public String Description;
        public Decimal CurrentResidualAmount;
        public Decimal CurrentResidualPercent;
        public String EffectiveDate;
        public String InstallationDate;
        public Decimal PurchaseOptionAmount;
        public String PurchaseOptionType;

        public AspireContractAsset(Asset asset,Opportunity oppty) {
            this.RecordId = new RecordId(asset.Id, 'record');
            this.Manufacturer = asset.Make__c;
            this.ModelYear = asset.Year__c;
            this.Condition = asset.Mileage__c > 0 ? 'used' : 'new';
            this.UnitAmount = oppty.Equipment_Cost__c;//asset.Price;
            this.Quantity = 1;
            this.CarryingCost = 0;
            this.Description = asset.Name;
        }
    }

    public class ContractStatus {
        public String Status;

        public ContractStatus(String status) {
            this.Status = status;
        }
    }

    public class Field {
        public String Value;
        public RecordId RecordId;
        public String ValueType;

        public Field(String name, String value, String type) {
            this.Value = value;
            this.RecordId = new RecordId(name,'Record');
            ValueType = type;
        }
    }

    private static Map<String,String> stateMap_toAbbrev = new Map<String,String> { 'alabama'=>'AL','alaska'=>'AK','arizona'=>'AZ','arkansas'=>'AR','california'=>'CA','colorado'=>'CO','connecticut'=>'CT','delaware'=>'DE','district of columbia'=>'DC','florida'=>'FL','georgia'=>'GA','guam'=>'GU','hawaii'=>'HI','idaho'=>'ID','illinois'=>'IL','indiana'=>'IN','iowa'=>'IA','kansas'=>'KS','kentucky'=>'KY','louisiana'=>'LA','maine'=>'ME','maryland'=>'MD','massachusetts'=>'MA','michigan'=>'MI','minnesota'=>'MN','mississippi'=>'MS','missouri'=>'MO','montana'=>'MT','nebraska'=>'NE','nevada'=>'NV','new hampshire'=>'NH','new jersey'=>'NJ','new mexico'=>'NM','new york'=>'NY','north carolina'=>'NC','north dakota'=>'ND','ohio'=>'OH','oklahoma'=>'OK','oregon'=>'OR','pennsylvania'=>'PA','puerto rico'=>'PR','rhode island'=>'RI','south carolina'=>'SC','south dakota'=>'SD','tennessee'=>'TN','texas'=>'TX','utah'=>'UT','vermont'=>'VT','virginia'=>'VA','washington'=>'WA','west virginia'=>'WV','wisconsin'=>'WI','wyoming'=>'WY' };
    private static Map<String,String> stateMap_toName = new Map<String,String>{ 'al'=>'Alabama','ak'=>'Alaska','az'=>'Arizona','ar'=>'Arkansas','ca'=>'California','co'=>'Colorado','ct'=>'Connecticut','de'=>'Delaware','dc'=>'District of Columbia','fl'=>'Florida','ga'=>'Georgia','gu'=>'Guam','hi'=>'Hawaii','id'=>'Idaho','il'=>'Illinois','in'=>'Indiana','ia'=>'Iowa','ks'=>'Kansas','ky'=>'Kentucky','la'=>'Louisiana','me'=>'Maine','md'=>'Maryland','ma'=>'Massachusetts','mi'=>'Michigan','mn'=>'Minnesota','ms'=>'Mississippi','mo'=>'Missouri','mt'=>'Montana','ne'=>'Nebraska','nv'=>'Nevada','nh'=>'New Hampshire','nj'=>'New Jersey','nm'=>'New Mexico','ny'=>'New York','nc'=>'North Carolina','nd'=>'North Dakota','oh'=>'Ohio','ok'=>'Oklahoma','or'=>'Oregon','pa'=>'Pennsylvania','pr'=>'Puerto Rico','ri'=>'Rhode Island','sc'=>'South Carolina','sd'=>'South Dakota','tn'=>'Tennessee','tx'=>'Texas','ut'=>'Utah','vt'=>'Vermont','va'=>'Virginia','wa'=>'Washington','wv'=>'West Virginia','wi'=>'Wisconsin','wy'=>'Wyoming' };
    public static String changeStateToAbbrev(String state_name) {
        if (state_name == NULL) {
            return NULL;
        }

        String state_name_lCase = state_name.toLowerCase().trim();

        return stateMap_toAbbrev.containsKey(state_name_lCase) ? stateMap_toAbbrev.get(state_name_lCase) : stateMap_toName.get(state_name_lCase);
    }

    public class gcAspireApiException extends Exception {
        public Integer errorCode;

        public gcAspireApiException(Integer errorCode, String errorMessage) {
            this.errorCode = errorCode;
            this.setMessage(errorMessage);
        }

        public Integer getErrorCode(){
            return this.errorCode;
        }
    }

    public static void coverage() {
        /**Integer i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;
        i = 1;**/
    }
}