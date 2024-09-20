import { LightningElement, wire } from 'lwc';
import getLiveEvents from '@salesforce/apex/LiveEventController.getLiveEvents';
import { NavigationMixin } from 'lightning/navigation';

export default class LiveEventsTable extends NavigationMixin(LightningElement) {
    events;
    error;

    columns = [
        {
            label: 'Event Name',
            fieldName: 'EventNameUrl',
            type: 'url',
            typeAttributes: { label: { fieldName: 'Event_Name__c' }, target: '_blank' }
        },
        { label: 'Start Date', fieldName: 'Start_Date_Time__c', type: 'date' },
        { label: 'Max Seats', fieldName: 'Max_Seats__c', type: 'number' }
    ];

    @wire(getLiveEvents)
    wiredEvents({ data, error }) {
        if (data) {
            this.events = data.map(event => {
                return {
                    ...event,
                    EventNameUrl: `/lightning/r/Event__c/${event.Id}/view`
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.events = undefined;
        }
    }

    // Optional: If you want to handle row click instead of URL in dataTable
    handleRowAction(event) {
        const eventId = event.detail.row.Id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: eventId,
                objectApiName: 'Event__c',
                actionName: 'view'
            }
        });
    }
}
