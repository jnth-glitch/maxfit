import { LightningElement, api, track, wire } from "lwc";
// import getEventDetails from "@salesforce/apex/EventDetailsController.getEventDetails";
import getAttendees from "@salesforce/apex/EventDetailsController.getAttendees";
import getSpeakers from "@salesforce/apex/EventDetailsController.getSpeakers";
import { getRecord } from 'lightning/uiRecordApi';

// Define the fields you want to retrieve using LDS
import EVENT_NAME_FIELD from '@salesforce/schema/Event__c.Event_Name__c';
import START_DATE_FIELD from '@salesforce/schema/Event__c.Start_Date_Time__c';
import LOCATION_FIELD from '@salesforce/schema/Event__c.Location__c';

import LOCATION_CITY_FIELD from '@salesforce/schema/Location__c.City__c'
import LOCATION_STATE_FIELD from '@salesforce/schema/Location__c.State__c'

export default class EventDetails extends LightningElement {
  @api recordId; // Event record ID

  event;
  @track speakers;
  @track speakerCnt = false;
  @track location;
  locationId='';
  @track attendees;
  @track attendeesCnt = false;
  error;
  cols = [
    { label: "Name", fieldName: "Name", type: "String" },
    { label: "Phone", fieldName: "Phone__c", type: "String" },
    { label: "Email", fieldName: "Email__c", type: "String" }
  ];
  // Fetch event details from the server
 

  // Fields to fetch using LDS
  fields = [EVENT_NAME_FIELD, START_DATE_FIELD, LOCATION_FIELD];

  @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
  wiredEventDetails({ error, data }) {
      if (data) {
          // Extract the necessary fields from the data
          this.event = {
              name: data.fields.Event_Name__c.value,
              startDate: data.fields.Start_Date_Time__c.value,
          };

          

          // Assuming Location is a lookup, you can get its name or the ID
          this.locationId = data.fields.Location__c.value;
          this.error = undefined;
      } else if (error) {
          this.error = error;
          this.event = undefined;
          this.location = undefined;
      }
  }

  locationFields= [LOCATION_CITY_FIELD,LOCATION_STATE_FIELD]
  @wire(getRecord,{recordId:'$locationId',fields:'$locationFields'})
  locationDetails({error,data}){
    if(data){
        
      this.location = {
        city:data.fields.City__c.value,
        state:data.fields.State__c.value
      }
      this.error= undefined;
    }
    if(error){
        this.error = error;
        this.location = undefined;
    }
}


  @wire(getAttendees, { eventId: "$recordId" })
  attendeeDetails({ error, data }) {
    if (data) {
      
      if (data.length > 0) {
        this.attendees = data;

        this.error = undefined;
      } else {
        this.attendeesCnt = true;
      }
    } else if (error) {
      this.error = error;
      this.attendees = undefined;
    }
  }

  @wire(getSpeakers, { eventId: "$recordId" })
  speakerDetails({ error, data }) {
    if (data) {

      if (data.length > 0) {
        this.speakers = data;

        this.error = undefined;
      } else {
        this.speakerCnt = true;
      }
    } else if (error) {
      this.error = error;
      this.speakers = undefined;
    }
  }
}
