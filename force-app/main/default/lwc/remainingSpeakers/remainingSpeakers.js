import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import getSpeakers from "@salesforce/apex/RemainingSpeakerAndAttendees.getSpeakers";

export default class RemainingSpeakers extends NavigationMixin(
  LightningElement
) {
  @api recordId; // Public property for the Event Id

  speakers;
  error;
  connectedCallback() {
    console.log("recordId", this.recordId);
}
  // Wire the Apex method to fetch speakers based on the eventId
  @wire(getSpeakers)
  wiredSpeakers({ data, error }) {
    console.log("Speakers: ", data, error, this.recordId);

    if (data) {
      this.speakers = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.speakers = undefined;
    }
  }

  // Method to handle the Add Speaker button click
  handleAddSpeaker(event) {
    console.log(event,this.recordId);
    
    const speakerId = event.target.dataset.id;
    // Prefill the speaker's information in the new Event_Speakers__c record
    const defaultValues = encodeDefaultFieldValues({
      Speaker__c: speakerId, // Prepopulate with the selected Speaker Id
      Event__c: this.recordId // Prefill the event ID
    });

    // Navigate to the 'new' page for Event_Speakers__c with prefilled values
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Event_Speaker__c",
        actionName: "new"
      },
      state: {
        defaultFieldValues: defaultValues
      }
    });
  }
}
