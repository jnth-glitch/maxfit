import { LightningElement } from 'lwc';

export default class SampleComponent extends LightningElement {
    handleAccountSelect(event) {
        const selectedAccount = event.detail;
        console.log('Selected Account:', selectedAccount);
        // alert('sakdml');
    }
}