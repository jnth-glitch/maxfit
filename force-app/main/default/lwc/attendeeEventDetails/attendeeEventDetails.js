import { LightningElement, api, wire, track } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/AttendeeEventController.getUpcomingEvents';
import getPastEvents from '@salesforce/apex/AttendeeEventController.getPastEvents';

export default class AttendeeEventDetails extends LightningElement {
    @api recordId;  // Attendee record ID passed from the detail page
    @track upcomingEvents = [];
    @track pastEvents = [];
    @track error;

    // Fetch upcoming events
    @wire(getUpcomingEvents, { attendeeId: '$recordId' })
    wiredUpcomingEvents({ data, error }) {
        if (data) {
            this.upcomingEvents = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.upcomingEvents = [];
        }
    }

    // Fetch past events
    @wire(getPastEvents, { attendeeId: '$recordId' })
    wiredPastEvents({ data, error }) {
        if (data) {
            this.pastEvents = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.pastEvents = [];
        }
    }
}
