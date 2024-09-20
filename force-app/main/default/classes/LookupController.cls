public with sharing class LookupController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchRecords(String searchKey, String objectApiName) {
        String query = 'SELECT Id, Name FROM ' + objectApiName + ' WHERE Name LIKE \'%' + searchKey + '%\' LIMIT 10';
        return Database.query(query);
    }
}
