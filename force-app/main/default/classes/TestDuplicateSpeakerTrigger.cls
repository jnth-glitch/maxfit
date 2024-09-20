/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
public class TestDuplicateSpeakerTrigger {

    @testSetup
    static void setupTestData() {
        // Create some test data that will be used in multiple test methods
        Event_Speaker__c speaker1 = new Event_Speaker__c(Name = 'John Doe', Event__c = 'Event1');
        Event_Speaker__c speaker2 = new Event_Speaker__c(Name = 'Jane Smith', Event__c = 'Event2');
        insert new List<Event_Speaker__c>{speaker1, speaker2};
    }

    @isTest
    static void testDuplicateSpeakerOnInsert() {
        // Create a new speaker that is a duplicate of an existing one
        Event_Speaker__c duplicateSpeaker = new Event_Speaker__c(Name = 'John Doe', Event__c = 'Event1');
        
        Test.startTest();
        try {
            insert duplicateSpeaker;
            System.assert(false, 'Duplicate speaker should not be inserted');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected DUPLICATE_VALUE exception');
        }
        Test.stopTest();
    }

    @isTest
    static void testDuplicateSpeakerOnUpdate() {
        // Retrieve an existing speaker
        Event_Speaker__c existingSpeaker = [SELECT Id, Name, Event__c FROM Event_Speaker__c WHERE Name = 'Jane Smith' LIMIT 1];
        
        // Update the speaker's name to match another speaker
        existingSpeaker.Name = 'John Doe';
        
        Test.startTest();
        try {
            update existingSpeaker;
            System.assert(false, 'Duplicate speaker should not be updated');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected DUPLICATE_VALUE exception');
        }
        Test.stopTest();
    }

    @isTest
    static void testNoDuplicateOnInsert() {
        // Create a new speaker that is not a duplicate
        Event_Speaker__c newSpeaker = new Event_Speaker__c(Name = 'Alice Johnson', Event__c = 'Event3');
        
        Test.startTest();
        insert newSpeaker;
        Test.stopTest();
        
        // Verify the new speaker was inserted
        Event_Speaker__c insertedSpeaker = [SELECT Id, Name FROM Event_Speaker__c WHERE Name = 'Alice Johnson' LIMIT 1];
        System.assertNotEquals(null, insertedSpeaker, 'New speaker should be inserted');
    }

    @isTest
    static void testNoDuplicateOnUpdate() {
        // Retrieve an existing speaker
        Event_Speaker__c existingSpeaker = [SELECT Id, Name, Event__c FROM Event_Speaker__c WHERE Name = 'Jane Smith' LIMIT 1];
        
        // Update the speaker's event to a new one
        existingSpeaker.Event__c = 'Event3';
        
        Test.startTest();
        update existingSpeaker;
        Test.stopTest();
        
        // Verify the speaker was updated
        Event_Speaker__c updatedSpeaker = [SELECT Id, Event__c FROM Event_Speaker__c WHERE Id = :existingSpeaker.Id];
        System.assertEquals('Event3', updatedSpeaker.Event__c, 'Speaker should be updated');
    }
}
