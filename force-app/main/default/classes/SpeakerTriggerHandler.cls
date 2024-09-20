public with sharing class SpeakerTriggerHandler {
  public static void handleDuplicate(List<Event_Speaker__c> esList) {


    //Fetching all the records 
    List<Event_Speaker__c> allES = [
      SELECT Event__c, Speaker__c
      FROM Event_Speaker__c
    ];
    Boolean flag = false;
    for (Event_Speaker__c es : esList) {
      flag = false;
      for (Event_Speaker__c e : allES) {
        if (es.Speaker__c == e.Speaker__c) {
          if (es.Event__c == e.Event__c) {

            //If event and speaker are same, duplicate is rejected
            flag = true;
            break;
          } else {

            //Fetching the start date and end date to check clash of the events
            Event__c e1 = [
              SELECT Start_Date_Time__c, End_Date_Time__c
              FROM Event__c
              WHERE id = :e.Event__c
            ][0];
            Event__c e2 = [
              SELECT Start_Date_Time__c, End_Date_Time__c
              FROM Event__c
              WHERE id = :es.Event__c
            ][0];
            if (
              overlappingEvents(e1,e2)
            ) {
              flag = true;
              break;
            }

            //Checking whether the curent event is already started 
        //     else if( e2.Start_Date_Time__c <= Datetime.now()){
        //       es.Speaker__c.addError(
        //   'Cannot have events that are already started'
        // );
            // }
          }
        }
      }
      if (flag) {
        es.Speaker__c.addError(
          'Cannot have more than one event for a speaker at a time'
        );
      }
    }
  }

  private static  Boolean overlappingEvents(Event__c e1,Event__c e2){

    //Companring start date, end date for overlapping
    if ((e2.End_Date_Time__c < e1.End_Date_Time__c && e2.End_Date_Time__c > e1.Start_Date_Time__c) ||
        (e2.Start_Date_Time__c < e1.End_Date_Time__c && e2.Start_Date_Time__c > e1.Start_Date_Time__c) ||
        (e2.Start_Date_Time__c > e1.Start_Date_Time__c && e2.End_Date_Time__c < e1.End_Date_Time__c) ||
        (e2.Start_Date_Time__c < e1.Start_Date_Time__c && e2.End_Date_Time__c > e1.End_Date_Time__c) 
      )
         { return true;}

            return false;
  }
}
 
 
