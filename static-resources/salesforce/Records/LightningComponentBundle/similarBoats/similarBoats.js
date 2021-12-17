import { LightningElement , api, wire} from 'lwc';
import getSimilarBoats from '@salesforce/apex/BoatDataService.getSimilarBoats';
import { NavigationMixin } from 'lightning/navigation';


// imports
// import getSimilarBoats
export default class SimilarBoats extends NavigationMixin(LightningElement){
    // Private
    currentBoat;
    relatedBoats;
    boatId = '';
    error;
    
    // public
    @api 
    get recordId() {
        return this.boatId;
      }
      set recordId(value) {
          this.boatId = value;
          // sets the boatId value
          // sets the boatId attribute
      }
    
    // public
    @api
    similarBy;
    
    // Wire custom Apex call, using the import named getSimilarBoats
    // Populates the relatedBoats list
    @wire(getSimilarBoats,{
        boatId: '$boatId',
        similarBy: '$similarBy'
    })
    similarBoats({ error, data }) {
        if(error){
            this.error = error;
            this.relatedBoats = undefined;
        }
        if(data){
            this.error = undefined;
            this.relatedBoats = data;
        }
     }



    get getTitle() {
      return 'Similar boats by ' + this.similarBy;
    }
    get noBoats() {
      return !(this.relatedBoats && this.relatedBoats.length > 0);
    }
    
    // Navigate to record page
    openBoatDetailPage(event) { 

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.boatId,
                objectApiName: 'Boat__c',
                actionName: 'view'
            }
        });
    }
  }