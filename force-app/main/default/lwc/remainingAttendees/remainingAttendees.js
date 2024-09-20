import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getAttendees from '@salesforce/apex/RemainingSpeakerAndAttendees.getAttendees';

export default class RemainingAttendees extends NavigationMixin(LightningElement) {
    @api recordId; // Public property for the Event Id

    attendees;
    noAttendees=false;
    error;

    // Wire the Apex method to fetch speakers based on the eventId
    @wire(getAttendees,{eventId:'$recordId'})
    wiredSpeakers({ data, error }) {
        if (data) {
            console.log('Attendee',data);
            if(data.length==0){
                this.noAttendees=true;
            }
            this.attendees = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.attendees = undefined;
        }
    }
 
    // Method to handle the Add Speaker button click
    handleAddAttendee(event) {
        const attendeeId = event.target.dataset.id;

        // Prefill the speaker's information in the new Event_Speakers__c record
        const defaultValues = encodeDefaultFieldValues({
            Attendee__c: attendeeId,  // Prepopulate with the selected Speaker Id
            Event__c: this.recordId // Prefill the event ID
        });

        // Navigate to the 'new' page for Event_Speakers__c with prefilled values
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event_Attendee__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}
