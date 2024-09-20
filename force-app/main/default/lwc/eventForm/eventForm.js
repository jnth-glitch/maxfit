import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'; // Import NavigationMixin
import EVENT_OBJECT from '@salesforce/schema/Event__c'; // Import Event object

export default class EventForm extends NavigationMixin(LightningElement) {
    eventName;
    startDate;
    endDate;
    maxAttendees;
    eventDetail;
    organizerId;
    locationId;

    handleChange(event) {
        console.log(event.target.value,event.target.dataset.id);
        
        const field = event.target.dataset.id;
        if (field === 'eventName') {
            this.eventName = event.target.value;
        } else if (field === 'startDate') {
            this.startDate = event.target.value;
        } else if (field === 'endDate') {
            this.endDate = event.target.value;
        } else if (field === 'maxAttendees') {
            this.maxAttendees = event.target.value;
        } else if (field === 'eventDetail') {
            this.eventDetail = event.target.value;
        }

    }
    handleSave() {
        const fields = {
            Event_Name__c: this.eventName,
            Start_Date_Time__c: this.startDate,
            End_Date_Time__c: this.endDate,
            Max_Seats__c: this.maxAttendees,
            Event_Detail__c: this.eventDetail,
            Event_Organizer__c: this.template.querySelector("[data-id='organizer']").value,
            Location__c: this.template.querySelector("[data-id='location']").value,
        };

        const recordInput = { apiName: EVENT_OBJECT.objectApiName, fields };
        console.log(recordInput);
        
        createRecord({ apiName: EVENT_OBJECT.objectApiName, fields })
            .then(eventRecord => {
                console.log(eventRecord);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Event created successfully',
                        variant: 'success',
                    })
                );

                // Use NavigationMixin to redirect to the Event detail page
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: eventRecord.id, // Use the created record's ID
                        objectApiName: 'Event__c', // The object API name
                        actionName: 'view', // The action name for viewing the record
                    },
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating Event',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }

    formatDateTime(dateString) {
        const date = new Date(dateString);
        return date.toISOString(); // Convert to ISO 8601 format
    }

    handleSuccess(event) {
        // Handle successful record save
        console.log('Record saved successfully', event.detail.id);
    }

    handleError(event) {
        // Handle record save error
        console.error('Error saving record', event.detail.message);
    }
}
