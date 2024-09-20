public with sharing class SpeakerController {
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getAllSpeakers() {
        // Query all speaker details from the Speaker__c object
        return [
            SELECT Id, Name, Email__c, Phone__c
            FROM Speaker__c
        ];
    }
}
