import { LightningElement , api, wire} from 'lwc';
import getAllReviews from '@salesforce/apex/BoatDataService.getAllReviews';
import { NavigationMixin } from 'lightning/navigation';

// imports
export default class BoatReviews extends NavigationMixin(LightningElement) {
    // Private
    boatId;
    error;
    boatReviews;
    isLoading;
    
    // Getter and Setter to allow for logic to run on recordId change
    @api
    get recordId() {
        return this.boatId;
     }
    set recordId(value) {
        this.boatId = value;
        console.log('calling setter method on boatReviews');
        this.getReviews();
      //sets boatId attribute
      //sets boatId assignment
      //get reviews associated with boatId
    }
    
    // Getter to determine if there are reviews to display
    get reviewsToShow() {
        return (this.boatReviews != null && this.boatReviews !== undefined && this.boatReviews.length ? true : false);
    }
    
    // Public method to force a refresh of the reviews invoking getReviews
    @api
    refresh() { 
        this.getReviews();
    }
    
    // Imperative Apex call to get reviews for given boat
    // returns immediately if boatId is empty or null
    // sets isLoading to true during the process and false when it’s completed
    // Gets all the boatReviews from the result, checking for errors.
   
    getReviews() {

        console.log('about to get the reviews from apex');

        if(!this.boatId) return;
        console.log('getting reviews because boat id is not null',this.boatId);
        this.isLoading = true;

        getAllReviews({boatId : this.boatId})
            .then((result) => {
                console.log('got a result!',result);
                this.boatReviews = result;
                this.error = undefined;
            })
            .catch((error) => {
                console.log('got an error');
                this.error = error;
                this.boatReviews = undefined;
            })
            .finally(() => {this.isLoading = false});
    }
    
    // Helper method to use NavigationMixin to navigate to a given record on click
    navigateToRecord(event) { 
        event.preventDefault();

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.recordId,
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }
  }