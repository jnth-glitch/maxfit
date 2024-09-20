public with sharing class EmailManager {
  public static void sendMail(
    List<String> addresses,
    List<String> subjects,
    List<String> bodies,
    Integer type
  ) {
     // Ensure that the lists are of the same size
    if(addresses.size() != subjects.size() || addresses.size() != bodies.size()) {
        throw new IllegalArgumentException('The size of addresses, subjects, and bodies lists must be the same.');
    }

     // Create a list to hold the email messages
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();


    // Iterate through the lists and create email messages
    for (Integer i = 0; i < addresses.size(); i++) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new List<String>{ addresses[i] });
      mail.setSubject(subjects[i]);
      if(Type==1){
        mail.setPlainTextBody(bodies[i]);
      }
      else{
        mail.setHtmlBody(bodies[i]);
      }

      emails.add(mail);
    }

    // Send all emails in a single call
    Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);

    // Inspect the results to determine if the emails were sent successfully
    // Call a helper method to inspect the returned results
    inspectResults(results);
  }

  // Helper method
  private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
    Boolean sendResult = true;
    // sendEmail returns an array of result objects.
    // Iterate through the list to inspect results.
    // In this class, the methods send only one email,
    // so we should have only one result.
    for (Messaging.SendEmailResult res : results) {
      if (res.isSuccess()) {
        System.debug('Email sent successfully');
      } else {
        sendResult = false;
        System.debug('The following errors occurred: ' + res.getErrors());
      }
    }
    return sendResult;
  }
}
