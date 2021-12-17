import { LightningElement, wire , api} from 'lwc';
import getBoatsByLocation from '@salesforce/apex/BoatDataService.getBoatsByLocation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

const LABEL_YOU_ARE_HERE = 'You are here!';
const ICON_STANDARD_USER = 'standard:user';
const ERROR_TITLE = 'Error loading Boats Near Me';
const ERROR_VARIANT = 'error';
export default class BoatsNearMe extends LightningElement {

    @api
    boatTypeId = '';
    mapMarkers = [];
    isLoading = true;
    isRendered;
    latitude;
    longitude;
  
  // Add the wired method from the Apex Class
  // Name it getBoatsByLocation, and use latitude, longitude and boatTypeId
  // Handle the result and calls createMapMarkers
    @wire(getBoatsByLocation, {
    latitude: '$latitude',
    longitude: '$longitude',
    boatTypeId: '$boatTypeId'
    })
    wiredBoatsJSON({error, data}) {
        if(data){
            this.createMapMarkers(data);
            this.isLoading = false;
        }

        if(error){
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: 'An error occurred',
                    variant: ERROR_VARIANT
                })
            );
        }   
    }
  
  // Controls the isRendered property
  // Calls getLocationFromBrowser()
  renderedCallback() {
     
      if(!this.isRendered){
        console.log('executing rendered callback');
          this.getLocationFromBrowser();
          this.isRendered = true;
      }
  }
  
  // Gets the location from the Browser
  // position => {latitude and longitude}
  getLocationFromBrowser() {

      if(navigator.geolocation){
        navigator.geolocation.getCurrentPosition(position => {
            this.latitude = position.coords.latitude;
            this.longitude = position.coords.longitude;
            console.log('position is ',this.latitude,this.longitude);
        });
      }
  }
  
  // Creates the map markers
  createMapMarkers(boatData) {

    let allBoats = JSON.parse(boatData);

    let boatMarkers = allBoats.map(boat => {

        return {
            location: {
                Latitude: boat.Geolocation__Latitude__s,
                Longitude: boat.Geolocation__Longitude__s
            },
            title: boat.Name
        }
    });

    let userMarker = {
        location: {
            Latitude: this.latitude,
            Longitude: this.longitude
        },
        icon: ICON_STANDARD_USER,
        title: LABEL_YOU_ARE_HERE
    }

    boatMarkers.unshift(userMarker);

    this.mapMarkers = boatMarkers;

  }
}