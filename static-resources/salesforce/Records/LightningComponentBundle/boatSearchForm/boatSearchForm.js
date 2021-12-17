import {LightningElement, wire, track} from 'lwc';
import getBoatTypes from '@salesforce/apex/BoatDataService.getBoatTypes';

export default class BoatSearchForm extends LightningElement {
    selectedBoatTypeId = '';
    
    // Private
    error = undefined;
    
    @track
    searchOptions;


    handleSearchOptionChange(event) {
        this.selectedBoatTypeId = event.target.value;
        const searchEvent = new CustomEvent('search', {
            detail: {
              boatTypeId : this.selectedBoatTypeId
            }
        });
      searchEvent;
      this.dispatchEvent(searchEvent);
    }

        
    @wire(getBoatTypes)
    boatTypes({ error, data }) {
        if (data) {
            this.searchOptions = data.map(type => {
            
                return {
                    label:type.Name,
                    value:type.Id
                }

            });
            this.searchOptions.unshift({ label: 'All Types', value: '' });
        } else if (error) {
            this.searchOptions = undefined;
            this.error = error;
        }
    }
    
   
    
  }