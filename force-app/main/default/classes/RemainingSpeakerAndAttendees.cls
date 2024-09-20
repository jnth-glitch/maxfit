public with sharing class RemainingSpeakerAndAttendees {
        @AuraEnabled(cacheable=true)
        public static List<Speaker__c> getSpeakers() {
            // List<Event_Speaker__c> lis = [SELECT Id, Name FROM Event_Speaker__c WHERE Event__c = eventId];
            List<Speaker__c> speakers = [SELECT Id, Name, Email__c, Phone__c, Profile_URL__c FROM Speaker__c WHERE Id NOT IN (SELECT Speaker__c FROM Event_Speaker__c )];
            return speakers;
        }
     
        @AuraEnabled(cacheable=true)
        public static List<Attendee__c> getAttendees(Id eventId) {
            // List<Event_Speaker__c> lis = [SELECT Id, Name FROM Event_Speaker__c WHERE Event__c = eventId];
            List<Attendee__c> attendees = [SELECT Id, Name, Email__c, Phone__c FROM Attendee__c WHERE Id NOT IN (SELECT Attendee__c FROM Event_Attendee__c WHERE Event__c = :eventId)];
            return attendees;
        }
}
