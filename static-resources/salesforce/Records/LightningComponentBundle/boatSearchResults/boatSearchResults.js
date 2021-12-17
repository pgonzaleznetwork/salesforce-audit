import {LightningElement, wire, api } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { MessageContext, publish } from 'lightning/messageService';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'


export default class BoatSearchResults extends LightningElement {

    selectedBoatId;
    boatTypeId = '';
    boats;
    isLoading = false;
    errors;
    boatsFromWire;

    columns = [
        { label: 'Name', fieldName: 'Name', editable: true },
        { label: 'Length', fieldName: 'Length__c', editable: true, type : 'number' },
        { label: 'Price', fieldName: 'Price__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
        { label: 'Description', fieldName: 'Description__c', editable: true }
    ];
    
    // wired message context
    @wire(MessageContext)
    messageContext;

    @wire(getBoats, {boatTypeId:'$boatTypeId'})
    wiredBoats ({error,data}) {
   
        if (error) {
            this.boats = undefined;
            this.errors = error;
        } else if (data) {
            this.boats = data;
            this.errors = undefined;
            
            
        }
        
    }


    
    // public function that updates the existing boatTypeId property
    // uses notifyLoading
    @api 
    searchBoats(boatTypeId) {
        this.boatTypeId = boatTypeId;
        this.isLoading = true;
        this.notifyLoading(this.isLoading);
    }
    
    // this public function must refresh the boats asynchronously
    // uses notifyLoading
    @api
    async refresh() { 
        this.isLoading = true;
        this.notifyLoading(true);
        console.log('standard lwc',this.template.querySelector('lightning-tabset'));
        return refreshApex(this.boats);
    }
    
    // this function must update selectedBoatId and call sendMessageService
    updateSelectedTile(event) {
        this.selectedBoatId = event.detail.boatId;
        this.sendMessageService(event.detail.boatId);
     }
    
    // Publishes the selected boat Id on the BoatMC.
    sendMessageService(boatId) { 
        const message = {recordId: boatId};
        publish(this.messageContext, BOATMC, message);
    }
    
    // This method must save the changes in the Boat Editor
    // Show a toast message with the title
    // clear lightning-datatable draft values
    handleSave(event) {
       
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));

        Promise.all(promises)
            .then(() => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Ship It!',
                        variant: 'success'
                    })
                );
                 // Clear all draft values
                this.draftValues = [];
                this.refresh().then(() => {
                    this.isLoading = false;
                    this.notifyLoading(this.isLoading);
                })
  
            })
            .catch(error => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'An error occurred',
                        variant: 'error'
                    })
                );
            })
            .finally(() => {

            });
    }
     //Check the current value of isLoading before dispatching the doneloading or loading custom event
    notifyLoading(isLoading) {

        if(isLoading){
            const loadingEvent = new CustomEvent('loading');
            this.dispatchEvent(loadingEvent);
        }
        else{
            const doneLoadingEvent = new CustomEvent('doneloading');
            this.dispatchEvent(doneLoadingEvent);
        }
    }
  }