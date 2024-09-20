public with sharing class EventDetailsController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getEventDetails(Id eventId) {
        Map<String, Object> eventDetails = new Map<String, Object>();

        // Fetch event details
        Event__c eventRecord = [SELECT Id, Name, Start_Date_Time__c, End_Date_Time__c, Max_Seats__c, Event_Organizer__r.Name
                                FROM Event__c WHERE Id = :eventId];


        // Fetch location details
        Location__c location = [SELECT Id, Name, City__c
                                FROM Location__c WHERE Id = :eventRecord.Location__c];


        // Add all fetched data to the map
        eventDetails.put('event', eventRecord);
        eventDetails.put('location', location);

        return eventDetails;
    }


    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getSpeakers(Id eventId){
    
        List<Speaker__c> speakers = [SELECT Id, Name, Email__c, Phone__c 
                                     FROM Speaker__c WHERE Id IN 
                                     (SELECT Speaker__c FROM Event_Speaker__c WHERE Event__c = :eventId)];
        return speakers;
    }


    @AuraEnabled(cacheable=true)
    public static List<Attendee__c> getAttendees(Id eventId){

        List<Attendee__c> attendees = [SELECT Id, Name, Email__c,Phone__c  FROM Attendee__c WHERE Id IN 
                                   (SELECT Attendee__c FROM Event_Attendee__c WHERE Event__c = :eventId)];
        return attendees;
    
    }
}
