trigger DuplicateSpeakerTrigger on Event_Speaker__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            SpeakerTriggerHandler.handleDuplicate(trigger.new);
        }
    }
}