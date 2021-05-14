/**
@description A collection of utility methods.
@date 2021-03-03
@author
**/


public with sharing class crossRoadsUtil {

    private class DummyException extends Exception {}
    private class FatalApplicationErrorException extends Exception {}
    private class InvalidCaseLoggingRecTypeException extends Exception {}
    private class DMLException extends Exception {}

    public static boolean sendLoggingToDebugLog = false;
    public static boolean testingSelf = false;
    private static Boolean throwDmlErrors = false;
    private static Boolean allOrNoneDML = false;
    private static String stackTrace = '';
    private static String mostRecentErrorMessage;
    private static Map<String, Boolean> diagMap = null;
    private static Set<String> bypassSet = new Set<String>();
    private static Id lastErrorLogId = null;
    private static List<Error__c> loggingCache = null;
    private static List<Database.SaveResult> lastInsertResult = null;
    private static List<Database.SaveResult> lastUpdateResult = null;
    private static List<Database.UpsertResult> lastUpsertResult = null;
    public static boolean isSandBoxOrg ;


public static void insertErrorLogRecord(string message, string errorCode, string className, string severityLevel)
    {
        Error__c el = new Error__c();
        el.Error_Description__c = message;
        el.Error_Code__c = errorCode;
        el.SeverityLevel__c = severityLevel;
        el.Class_Name__c = className;
        Database.insert(el, false);
        //insertSalesforceDB(el,'Logging');
        
    }


   /* @param objects - a List of SObjects for inserting.
    * @param header - string to put at the start of any error message generated.
    * @return List<integer> - [0] = count of failed records, [1] = count of successful records, [2] = total records processed, [3] = [reserved for future use], [4] = [reserved for future use], [5...] = indexes of failed records in input List
    */
    public static List<integer> insertSalesforceDB(List<SObject> objects, string header)
    {
        if (! objects.isEmpty()){
            Database.SaveResult[] dsr = Database.insert(objects, allOrNoneDML);
            lastInsertResult = dsr;
            if (header == null) header = '';
            integer[] results = analyzeDatabaseSaveResults(dsr, objects, '(insertSalesforceDB) ' + header);
            if (results[0] > 0) {
                if (throwDmlErrors) {
                    throw new DMLException(mostRecentErrorMessage);
                }
            }
            return results;
        } else {
            return null;
        }
    }

    /**
    * @description General purpose Database.SaveResult analyzer and error logger.
    * 
    * @param dbResults - a Database.SaveResult array from a Database.update() or Database.insert() operation
    * @param objects - List of SObjects involved in the operation
    * @param header - heading for error report
    * @return List<integer> - [0] = count of failed records, [1] = count of successful records, [2] = total records processed, [3] = [reserved for future use], [4] = [reserved for future use], [5...] = indexes of failed records in input List
    */
    public static List<integer> analyzeDatabaseSaveResults(Database.SaveResult[] dbResults,
                                                        List<SObject> objects,
                                                        string header) {
        integer successes = 0;
        integer failures = 0;
        integer recordNum = 0;
        String errorCode = '';
        boolean moreErrors = false;
        
        string errorReport = (String.isNotBlank(header)) ? ((header + ' ').trim()) : '';
        List<integer> reportInfo = new List<integer>();
        
        if (dbResults == null) return null;
        
        // Add five elements to start the results list
        for (integer i = 0; i < 5; i++) reportInfo.add(0);

        try {
            for (Database.SaveResult sr : dbResults) {
                if (! sr.isSuccess()){
                    reportInfo.add(recordNum); // Add the index of the failed record
					if (failures == 0) {
						errorReport += ' [' + (objects.get(0).getSObjectType().getDescribe().getName()+'') + '] ';
					}
                    failures++;
                    List<Database.Error> errList = sr.getErrors();
                    String err = '';
                    for (Database.Error de : errList) {
                        String statusCode = String.valueOf(de.getStatusCode());
                        errorCode = (errorCode + ((String.isNotBlank(errorCode)) ? ', ' : '') + statusCode).abbreviate(255);
                        err += statusCode + ': ' + de.getMessage() + '{' + de.getFields() + '}; ';
                    }
                    err = err.replaceAll('\\{\\(', '{').replaceAll('\\)\\}', '}');

                    if (errorReport.length() + err.length() < 130000)
                    {
                        errorReport += ' (' + String.valueOf(failures) + ') ' +
                            '[' + objects.get(recordNum).Id + '] ' + err + '\n';
                    } else if (! moreErrors) {
                        errorReport = errorReport + 'Additional errors not reported for lack of log space';
                        moreErrors = true;
                    }
                }
                else {
                    successes++;
                }
                recordNum++;
            }

            if (failures > 0)
            {
                insertErrorLogRecord(errorReport, 'Error', errorCode, 'DML Save');
            }
        } catch (Exception e) {
               insertErrorLogRecord(e.getMessage(), 'Problem analyzing DB results','','');
               if (throwDmlErrors) throw e;
        }

        reportInfo.set(0, failures);
        reportInfo.set(1, successes);
        reportInfo.set(2, (successes + failures));
        return reportInfo;
    }


    /**
      @description Check whether this org is sandbox or production
      @return boolean  - true or false - true if sandbox
     */
    public static Boolean runningInASandbox() {
        if(isSandBoxOrg == null) {    
            isSandBoxOrg = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            return isSandBoxOrg;
        } else { 
            return isSandBoxOrg;
		}
    }

    /***
     * readCustomMetadata for Endpoints
     * 
     */

     public   static List<CrossRoad_APIEndpoint__mdt> getAPIMetaEndpointInfo() {
            String sandbox = 'UAT';
            String recordFilter = '';
            if(!runningInASandbox()){
                sandbox = 'Prod';
            }
            recordFilter = '%'+sandbox;
            List<CrossRoad_APIEndpoint__mdt> data =[SELECT Label,ACCOUNT_UDFs_ENDPOINT__c,ADD_ASSETS_TO_CONTRACT_ENDPOINT__c,
                                                    AZURE_ASPIRE_BASEURL__c,CREATE_ASSET_ENDPOINT__c,
                                                    CREATE_BANK_ACCOUNT_ENDPOINT__c,CREATE_COMMENT_ENDPOINT__c,
                                                    CREATE_CONTRACT_ENDPOINT__c,CREATE_CUSTOMER_ENDPOINT__c,
                                                    CREATE_LOCATION_ENDPOINT__c,CREATE_TRANSACTION_ENDPOINT__c,
                                                    RELATED_ACCOUNTS_ENDPOINT__c,CONTRACT_STATUS_ENDPOINT__c

                                                    FROM CrossRoad_APIEndpoint__mdt 
                                                    WHERE Label like :recordFilter];


            return data;


         
     }

   

    
}