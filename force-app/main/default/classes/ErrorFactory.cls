public with sharing class ErrorFactory {
  public static void addErrorLog(
    Datetime errorDateTime,
    String logDetails,
    String processName
  ) {
    Error_Log__c e = new Error_Log__c();
    e.Log_Date_Time__c = errorDateTime;
    e.Log_Details__c = logDetails;
    e.Process_Name__c = processName;
    try {
      insert e;
    } catch (Exception ex) {
      System.debug(ex.getMessage());
    }
  }
}
