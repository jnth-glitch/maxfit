import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/LookupController.searchRecords';

export default class CustomLookup extends LightningElement {
    @api label;
    @api placeholder = 'Search...';
    @api objectApiName;
    @api iconName = 'standard:account';

    @track searchResults = [];
    @track showDropdown = false;

    handleInputChange(event) {
        const searchKey = event.target.value;

        if (searchKey.length >= 2) {
            searchRecords({ searchKey: searchKey, objectApiName: this.objectApiName })
                .then(result => {
                    console.log(result);
                    
                    this.searchResults = result;
                    this.showDropdown = true;
                })
                .catch(error => {
                    this.searchResults = [];
                    this.showDropdown = false;
                    console.error('Error:', error);
                });
        } else {
            this.searchResults = [];
            this.showDropdown = false;
        }
    }

    handleOptionSelect(event) {
        const recordId = event.currentTarget.dataset.id;
        const selectedRecord = this.searchResults.find(record => record.Id === recordId);

        this.dispatchEvent(new CustomEvent('select', { detail: selectedRecord }));

        this.searchResults = [];
        this.showDropdown = false;
    }
}
