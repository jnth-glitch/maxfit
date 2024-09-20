@RestResource(urlMapping='/events/')
global with sharing class EventRestService {
 
    @HttpGet
    global static List<Event__c> getLiveEvents() {
        List<Event__c> liveEvents = [
            SELECT Id, Name, Start_Date_Time__c, End_Date_Time__c, Location__r.Name, Max_Seats__c, Event_Detail__c
            FROM Event__c
            WHERE Start_Date_Time__c > TODAY AND Live__c = true
        ];
       
        for (Event__c event : liveEvents) {
            System.debug('Event: ' + event.Name + ', Start Date: ' + event.Start_Date_Time__c);
        }
 
        return liveEvents;
    }
}