public class PurgeOldEventsBatch implements Database.Batchable<SObject>, Database.Stateful {

    // List to store purged event details
    private List<Event__c> purgedEvents = new List<Event__c>();

    // Query to select events that are more than 2 months old and have been organized
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id,Event_Name__c,End_Date_Time__c,Event_Organizer__r.Name FROM Event__c WHERE End_Date_Time__c < LAST_N_MONTHS:2 AND Live__c = false';
        return Database.getQueryLocator(query);
    }

    // Execute method to delete the selected events and store details for the email
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Event__c> eventsToDelete = (List<Event__c>) scope;
        // Storing purged events for email reporting
        purgedEvents.addAll(eventsToDelete);
        delete eventsToDelete;
    }

    // Finish method to send an HTML email with details of the purged events
    public void finish(Database.BatchableContext bc) {
        // Constructing the HTML email body with event details
        String emailBody = '<html><body>';
        emailBody += '<h1>Purge Old Events Batch Execution</h1>';
        emailBody += '<p>The batch process to purge old events has completed successfully. Below are the details of the purged events:</p>';
        emailBody += '<table border="1" cellpadding="5" cellspacing="0">';
        emailBody += '<tr><th>Event Name</th><th>End Date</th><th>Organizer</th></tr>';

        for (Event__c event : purgedEvents) {
            emailBody += '<tr>';
            emailBody += '<td>' + event.Event_Name__c + '</td>';
            emailBody += '<td>' + event.End_Date_Time__c.format() + '</td>';
            emailBody += '<td>' + event.Event_Organizer__r.Name + '</td>';
            emailBody += '</tr>';
        }

        emailBody += '</table>';
        emailBody += '<p>Total Events Purged: ' + purgedEvents.size() + '</p>';
        emailBody += '</body></html>';

        
        String toAddress = 'jayanthraju2k2@gmail.com';
        String subject = 'Purge Old Events Batch Execution';

        
        EmailManager.sendMail(new List<String>{toAddress},new List<String> {subject},new List<string>{emailBody}, 0); // Passing true to indicate it's an HTML email
    }
}
