trigger AttendeeEmailTrigger on Event_Attendee__c (after insert) {
  
        AttendeeTriggerHandler.sendRegistrationMail(Trigger.new);
    
}