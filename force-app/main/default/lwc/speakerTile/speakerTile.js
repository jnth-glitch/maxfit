import { LightningElement, wire } from 'lwc';
import getAllSpeakers from '@salesforce/apex/SpeakerController.getAllSpeakers';

export default class SpeakerTile extends LightningElement {
    speakers;
    error;

    // Wire the Apex method to fetch all speaker details
    @wire(getAllSpeakers)
    wiredSpeakers({ error, data }) {
        if (data) {
            this.speakers = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.speakers = undefined;
        }
    }
}
