trigger LocationTrigger on Location__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate)
       { LocationValidator.VerifyLocation(Trigger.new);}
    }

}