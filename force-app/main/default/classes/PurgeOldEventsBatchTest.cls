@IsTest
public class PurgeOldEventsBatchTest {

    @TestSetup
    static void setup() {
        // Create test Event_Organizer__c records
        Event_Organizer__c organizer1 = new Event_Organizer__c(Name = 'Organizer One', Phone__c = '1234567890', Email__c = 'org1@example.com');
        Event_Organizer__c organizer2 = new Event_Organizer__c(Name = 'Organizer Two', Phone__c = '0987654321', Email__c = 'org2@example.com');
        insert new List<Event_Organizer__c>{organizer1, organizer2};

        // Create test Event__c records
        List<Event__c> events = new List<Event__c>{
            new Event__c(Event_Name__c = 'Event 1', Start_Date_Time__c = System.now().addMonths(-4), End_Date_Time__c = System.now().addMonths(-3), Max_Seats__c = 100, Event_Organizer__c = organizer1.Id, Live__c = false),
            new Event__c(Event_Name__c = 'Event 2', Start_Date_Time__c = System.now().addMonths(-5), End_Date_Time__c = System.now().addMonths(-4), Max_Seats__c = 150, Event_Organizer__c = organizer2.Id, Live__c = false),
            new Event__c(Event_Name__c = 'Event 3', Start_Date_Time__c = System.now().addMonths(-2), End_Date_Time__c = System.now().addMonths(-1), Max_Seats__c = 200, Event_Organizer__c = organizer1.Id, Live__c = true), // This one should not be deleted
            new Event__c(Event_Name__c = 'Event 4', Start_Date_Time__c = System.now().addMonths(-3), End_Date_Time__c = System.now().addMonths(-2), Max_Seats__c = 250, Event_Organizer__c = organizer2.Id, Live__c = false)
        };
        insert events;
    }

    @IsTest
    static void testBatchExecution() {
        // Query for events before running the batch to confirm they exist
        Integer initialCount = [SELECT COUNT() FROM Event__c WHERE End_Date_Time__c <= LAST_N_MONTHS:2 AND Live__c = false];

        // Execute the batch
        Test.startTest();
        PurgeOldEventsBatch batch = new PurgeOldEventsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Query for events after running the batch
        Integer finalCount = [SELECT COUNT() FROM Event__c WHERE End_Date_Time__c < LAST_N_MONTHS:2 AND Live__c = false];

        // Check that the correct number of records were deleted
        System.assertEquals(0, finalCount);
        System.assertEquals(initialCount, 3); // Only 3 should be deleted as one has Live__c = true

    }
}
