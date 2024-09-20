public with sharing class LocationTriggerHandler {
    public static void VerifyLocation(List<Location__c> locList){
    for(Location__c loc: locList){
        if(LocationValidator.ValidateLocation(loc.Name, loc.Street__c, loc.City__c, loc.State__c, loc.Postal_Code__c, loc.Country__c)){
            loc.Verified__c = true;
        }
        else{
            loc.addError('Enter valid address');
        }
    }
    }
}