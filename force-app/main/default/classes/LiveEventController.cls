public with sharing class LiveEventController {
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getLiveEvents() {
        return [SELECT Id, Event_Name__c, Start_Date_Time__c, Max_Seats__c 
                FROM Event__c 
                WHERE Live__c = true 
                AND Start_Date_Time__c >= TODAY 
                ORDER BY Start_Date_Time__c ASC];
    }
}
