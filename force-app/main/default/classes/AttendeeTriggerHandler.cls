public with sharing class AttendeeTriggerHandler {
  public static void sendRegistrationMail(
    List<Event_Attendee__c> attendeeList
  ) {
    // System.debug(attendeeList);
    List<String> toAddresses = new List<String>();
    List<String> subjects = new List<String>();
    List<String> bodies = new List<String>();
    for (Event_Attendee__c ea : attendeeList) {
      List<Attendee__c> attendee = [
        SELECT Name, Email__c, Phone__c
        FROM Attendee__c
        WHERE id = :ea.Attendee__c
      ];
      List<Event__c> event = [
        SELECT
          Event_Name__c,
          Start_Date_Time__c,
          Location__r.Name,
          Event_Organizer__r.Name
        FROM Event__c
        WHERE id = :ea.Event__c
      ];
      Attendee__c a = attendee[0];
      Event__c e = event[0];
      String toAddress = a.Email__c;
      String Subject = 'Pass for the ' + e.Event_Name__c;
      String Body =
        'Dear ' +
        a.Name +
        ',\n' +
        'Thank you for registering for ' +
        e.Event_Name__c +
        ' which will be organized on ' +
        e.Start_Date_Time__c +
        ' & will be held in ' +
        e.Location__r.Name +
        '. We are excited to have you, see you in the event.' +
        '\nFind the Google Map Location for the Event Here (https://www.google.com/maps/place/' +
        e.Location__r.Name +
        ')' +
        '\n\nThanks,\n' +
        e.Event_Organizer__r.Name;
      System.debug('Event Name:' + e.Event_Name__c);
      System.debug('Attendee Name:' + a.Name);
      System.debug('Event Date:' + e.Start_Date_Time__c);
      System.debug('Location:' + e.Location__r.Name);
      System.debug('Organizer Name:' + e.Event_Organizer__r.Name);
      System.debug('https://www.google.com/maps/place/' + e.Location__r.Name);
      System.debug(Body);
      toAddresses.add(toAddress);
      subjects.add(Subject);
      bodies.add(Body);
    }
    EmailManager.sendMail(toAddresses, subjects, bodies,1);
  }
}
