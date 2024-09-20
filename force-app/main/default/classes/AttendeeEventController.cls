public class AttendeeEventController {
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getUpcomingEvents(Id attendeeId) {
        // Query for upcoming events the attendee is registered for
        return [
            SELECT Id, Event_Name__c, Start_Date_Time__c, End_Date_Time__c, Location__r.Name, 
                   (SELECT Speaker__r.Name FROM Event_Speakers__r),
                   (SELECT Attendee__r.Name FROM Event_Attendees__r)
            FROM Event__c
            WHERE Id IN (SELECT Event__c FROM Event_Attendee__c WHERE Attendee__c = :attendeeId)
            AND Start_Date_Time__c >= :Date.today()
            ORDER BY Start_Date_Time__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getPastEvents(Id attendeeId) {
        // Query for past events the attendee attended
        return [
            SELECT Id, Event_Name__c, Start_Date_Time__c, End_Date_Time__c, Location__r.Name, 
                   (SELECT Speaker__r.Name FROM Event_Speakers__r),
                   (SELECT Attendee__r.Name FROM Event_Attendees__r)
            FROM Event__c
            WHERE Id IN (SELECT Event__c FROM Event_Attendee__c WHERE Attendee__c = :attendeeId)
            AND Start_Date_Time__c < :Date.today()
            ORDER BY Start_Date_Time__c DESC
        ];
    }
}
