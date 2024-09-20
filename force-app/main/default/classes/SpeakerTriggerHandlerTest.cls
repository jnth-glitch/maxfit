@isTest
public class SpeakerTriggerHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create sample event organizers
        Event_Organizer__c organizer1 = new Event_Organizer__c(Name = 'Organizer 1', Phone__c = '1234567890', Email__c = 'organizer1@example.com');
        Event_Organizer__c organizer2 = new Event_Organizer__c(Name = 'Organizer 2', Phone__c = '0987654321', Email__c = 'organizer2@example.com');
        insert new List<Event_Organizer__c>{organizer1, organizer2};
        
        // Create sample events
        Event__c event1 = new Event__c(
            Event_Name__c = 'Event 1', 
            Start_Date_Time__c = DateTime.now().addDays(1), 
            End_Date_Time__c = DateTime.now().addDays(3), 
            Max_Seats__c = 100, 
            Event_Organizer__c = organizer1.Id,
            Live__c= True
        );
        Event__c event2 = new Event__c(
            Event_Name__c = 'Event 2', 
            Start_Date_Time__c = DateTime.now().addDays(3), 
            End_Date_Time__c = DateTime.now().addDays(5), 
            Max_Seats__c = 150, 
            Event_Organizer__c = organizer2.Id,
            Live__c= True
        );
        Event__c event3 = new Event__c(
            Event_Name__c = 'Event 3', 
            Start_Date_Time__c = DateTime.now().addDays(5), 
            End_Date_Time__c = DateTime.now().addDays(7), 
            Max_Seats__c = 200, 
            Event_Organizer__c = organizer1.Id,
            Live__c= True
        );
        insert new List<Event__c>{event1, event2, event3};

        // Create sample speakers
        Speaker__c speaker1 = new Speaker__c(Name = 'Speaker A', Phone__c = '1111111111', Email__c = 'speakerA@example.com');
        Speaker__c speaker2 = new Speaker__c(Name = 'Speaker B', Phone__c = '2222222222', Email__c = 'speakerB@example.com');
        insert new List<Speaker__c>{speaker1, speaker2};
        
        // Create sample event speakers
        Event_Speaker__c eventSpeaker1 = new Event_Speaker__c(Event__c = event1.Id, Speaker__c = speaker1.Id);
        Event_Speaker__c eventSpeaker2 = new Event_Speaker__c(Event__c = event2.Id, Speaker__c = speaker2.Id);
        insert new List<Event_Speaker__c>{eventSpeaker1, eventSpeaker2};
    }

    @isTest
    static void testDuplicateSpeaker() {
        // Retrieve existing events and speakers
        Event__c event1 = [SELECT Id FROM Event__c WHERE Event_Name__c = 'Event 1' LIMIT 1];
        Speaker__c speaker1 = [SELECT Id FROM Speaker__c WHERE Name = 'Speaker A' LIMIT 1];
        
        // Create a duplicate event speaker
        Event_Speaker__c duplicateSpeaker = new Event_Speaker__c(Event__c = event1.Id, Speaker__c = speaker1.Id);
        
        Test.startTest();
        try {
            insert duplicateSpeaker;
            System.assert(false, 'Duplicate speaker should not be inserted');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot have more than one event for a speaker at a time'), 'Expected duplicate speaker error');
        }
        Test.stopTest();
    }

    @isTest
    static void testOverlappingEvents() {
        // Retrieve existing events and speaker
        Event__c event1 = [SELECT Id FROM Event__c WHERE Event_Name__c = 'Event 1' LIMIT 1];
        Event__c event2 = [SELECT Id FROM Event__c WHERE Event_Name__c = 'Event 2' LIMIT 1];
        Speaker__c speaker1 = [SELECT Id FROM Speaker__c WHERE Name = 'Speaker A' LIMIT 1];
        
        // Create a speaker for an overlapping event
        Event_Speaker__c overlappingSpeaker = new Event_Speaker__c(Event__c = event2.Id, Speaker__c = speaker1.Id);
        
        Test.startTest();
        try {
            insert overlappingSpeaker;
            System.assert(false, 'Overlapping event speaker should not be inserted');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot have more than one event for a speaker at a time'), 'Expected overlapping event error');
        }
        Test.stopTest();
    }

    @isTest
    static void testNonOverlappingEvents() {
        // Retrieve existing events and speaker
        Event__c event3 = [SELECT Id FROM Event__c WHERE Event_Name__c = 'Event 3' LIMIT 1];
        Speaker__c speaker1 = [SELECT Id FROM Speaker__c WHERE Name = 'Speaker A' LIMIT 1];
        
        // Create a speaker for a non-overlapping event
        Event_Speaker__c nonOverlappingSpeaker = new Event_Speaker__c(Event__c = event3.Id, Speaker__c = speaker1.Id);
        
        Test.startTest();
        insert nonOverlappingSpeaker;
        Test.stopTest();
        
        // Verify the speaker was inserted
        Event_Speaker__c insertedSpeaker = [SELECT Id FROM Event_Speaker__c WHERE Id = :nonOverlappingSpeaker.Id LIMIT 1];
        System.assertNotEquals(null, insertedSpeaker, 'Non-overlapping event speaker should be inserted');
    }
    
    @isTest
    static void testNonDuplicateSpeaker() {
        // Retrieve existing events and speakers
        Event__c event3 = [SELECT Id FROM Event__c WHERE Event_Name__c = 'Event 3' LIMIT 1];
        Speaker__c speaker2 = [SELECT Id FROM Speaker__c WHERE Name = 'Speaker B' LIMIT 1];
        
        // Create a non-duplicate event speaker
        Event_Speaker__c nonDuplicateSpeaker = new Event_Speaker__c(Event__c = event3.Id, Speaker__c = speaker2.Id);
        
        Test.startTest();
        insert nonDuplicateSpeaker;
        Test.stopTest();
        
        // Verify the speaker was inserted
        Event_Speaker__c insertedSpeaker = [SELECT Id FROM Event_Speaker__c WHERE Id = :nonDuplicateSpeaker.Id LIMIT 1];
        System.assertNotEquals(null, insertedSpeaker, 'Non-duplicate speaker should be inserted');
    }
}
