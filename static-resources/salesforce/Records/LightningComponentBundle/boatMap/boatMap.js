import {LightningElement, wire, api } from 'lwc';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { getRecord } from 'lightning/uiRecordApi';

const LONGITUDE_FIELD = 'Boat__c.Geolocation__Longitude__s';
const LATITUDE_FIELD = 'Boat__c.Geolocation__Latitude__s';
const  BOAT_FIELDS = [LONGITUDE_FIELD,LATITUDE_FIELD];
console.log(BOAT_FIELDS);

// Declare the const LONGITUDE_FIELD for the boat's Longitude__s
// Declare the const LATITUDE_FIELD for the boat's Latitude
// Declare the const BOAT_FIELDS as a list of [LONGITUDE_FIELD, LATITUDE_FIELD];
export default class BoatMap extends LightningElement {
  // private
  subscription = null;
  boatId;

  // Getter and Setter to allow for logic to run on recordId change
  // this getter must be public
  @api
  get recordId() {
    return this.boatId;
  }

  set recordId(value) {
    this.setAttribute('boatId', value);
    this.boatId = value;
  }

  //public
  error = undefined;
  mapMarkers = [];

  // Initialize messageContext for Message Service
  @wire(MessageContext)
  messageContext;

  // Runs when component is connected, subscribes to BoatMC
  connectedCallback() {
    // recordId is populated on Record Pages, and this component
    // should not update when this component is on a record page.
    if (this.subscription || this.recordId) {
      return;
    }
    // Subscribe to the message channel to retrieve the recordID and assign it to boatId.
    this.subscription = subscribe(this.messageContext, BOATMC, (message) => {
      console.log('got event from another component',message);
      this.recordId = message.recordId;
      console.log('new boatId value: ',this.boatId);
    }, { scope: APPLICATION_SCOPE });
  }

  disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  // Getting record's location to construct map markers using recordId
  // Wire the getRecord method using ('$boatId')
  @wire(getRecord, { recordId: '$boatId', fields: BOAT_FIELDS })
  wiredRecord({ error, data }) {
    // Error handling
    if (data) {
      console.log('got data from wiredRecord',data);
      this.error = undefined;
      const longitude = data.fields.Geolocation__Longitude__s.value;
      const latitude = data.fields.Geolocation__Latitude__s.value;
      this.updateMap(longitude, latitude);
    } else if (error) {
      console.log('got error from wiredRecord',error);
      this.error = error;
      this.boatId = undefined;
      this.mapMarkers = [];
    }
  }

  
  // Creates the map markers array with the current boat's location for the map.
  updateMap(Longitude, Latitude) {

    let markers = [{
      location: {Latitude: Latitude,Longitude: Longitude}
    }];

    this.mapMarkers = markers;
  }

  // Getter method for displaying the map component, or a helper method.
  get showMap() {
    return this.mapMarkers.length > 0;
  }
}