// Custom Labels Imports
// import labelDetails for Details
// import labelReviews for Reviews
// import labelAddReview for Add_Review
// import labelFullDetails for Full_Details
// import labelPleaseSelectABoat for Please_select_a_boat
// Boat__c Schema Imports
// import BOAT_ID_FIELD for the Boat Id
// import BOAT_NAME_FIELD for the boat Name


import { LightningElement, wire } from 'lwc';
import { getRecord , getFieldValue} from 'lightning/uiRecordApi';

import labelPleaseSelectABoat from '@salesforce/label/c.Please_select_a_boat';
import labelDetails from '@salesforce/label/c.Details';
import labelReviews from '@salesforce/label/c.Reviews';
import labelAddReview from '@salesforce/label/c.Add_Review';
import labelFullDetails from '@salesforce/label/c.Full_Details';

import BOAT_ID_FIELD from '@salesforce/schema/Boat__c.Id';
import BOAT_NAME_FIELD from '@salesforce/schema/Boat__c.Name';

import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';

import { NavigationMixin } from 'lightning/navigation';

const BOAT_FIELDS = [BOAT_ID_FIELD, BOAT_NAME_FIELD];

export default class BoatDetailTabs extends NavigationMixin(LightningElement) {

    objectApiName = 'Boat__c';
    boatId;

    @wire(getRecord, { recordId: '$boatId', fields: BOAT_FIELDS})
    wiredRecord;

    label = {
        labelDetails,
        labelReviews,
        labelAddReview,
        labelFullDetails,
        labelPleaseSelectABoat,
    };
    
  // Decide when to show or hide the icon
  // returns 'utility:anchor' or null
  get detailsTabIconName() {
    return (this.wiredRecord.data ? 'utility:anchor' : null);
  }
  
  // Utilize getFieldValue to extract the boat name from the record wire
  get boatName() {
    return getFieldValue(this.wiredRecord.data, BOAT_NAME_FIELD);
  }
  
  // Private
  subscription = null;

  // Initialize messageContext for Message Service
  @wire(MessageContext)
  messageContext;
  
  // Subscribe to the message channel
  subscribeMC() {
      // recordId is populated on Record Pages, and this component
    // should not update when this component is on a record page.
    if (this.subscription || this.recordId) {
        return;
      }
      // Subscribe to the message channel to retrieve the recordID and assign it to boatId.
      this.subscription = subscribe(this.messageContext, BOATMC, (message) => {
          console.log('reviews component getting message',message);
        this.boatId = message.recordId;
      }, { scope: APPLICATION_SCOPE });
  }
  
  // Calls subscribeMC()
  connectedCallback() {
      this.subscribeMC();
  }
  
  // Navigates to record page
  navigateToRecordViewPage() {

    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.boatId,
            objectApiName: 'Boat__c',
            actionName: 'view'
        }
    });
  }
  
  // Navigates back to the review list, and refreshes reviews component
  handleReviewCreated() {
    console.log('event being handled on parent after form is submitted');
    this.template.querySelector('lightning-tabset').activeTabValue = 'reviews';
    this.template.querySelector('c-boat-reviews').refresh();
    //need to refresh the boats review dynamically, maybe calling a public API on that component

  }
}