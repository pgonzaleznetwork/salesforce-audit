import { LightningElement } from 'lwc';
import getAllObjects from '@salesforce/apex/EasyCrudAndFls.getAllObjects';

export default class EasyCrudAllObjects extends LightningElement {

        allObjectsInOrg = [];
        isLoading = false;
        status = '';
        showObjectCrud = false;
        showFls = false;
        object = '';
        filteredObjects = [];
        connectedCallback(){
            this.getObjects();
        }

        getObjects(){
            this.isLoading = true;
            this.status = 'Please Wait while we are fetching all the objects in the Org..'
            getAllObjects({

            }).then(result => {
                this.status = 'Fetched Objects Sucessfully..'
                let count = 1;
                result = JSON.parse(JSON.stringify(result));
                for(var item of result){
                        if(count > 110){
                            count = 1;
                        }
                        item.icon = 'custom:custom'+count;
                        item.isVisible = true;
                        count += 1;
                }
                this.allObjectsInOrg = result;
                this.filteredObjects = JSON.parse(JSON.stringify(result));
                this.isLoading = false;
                this.status = '';
            }).catch(error => {
                console.log(error);
            })
        }

        handleObjectSearch(event){
                var searchKey = event.detail.value;
                let filteredResults = [];
                for(var item of this.allObjectsInOrg){
                    if(!searchKey || item.SobjectType.toLowerCase().includes(searchKey.toLowerCase())){
                        filteredResults.push(item);
                    }
                }
                this.filteredObjects = filteredResults;
        }
        handleCrud(event){
            this.object = event.target.name;
            this.showObjectCrud = true;
            this.showFls = false;
        }
        

        closeModal(event){
            this.showObjectCrud =false;
            this.showFls = false;
        }

        handleFls(event){

            this.object = event.target.name;
            this.showObjectCrud = false;
            this.showFls = true;
        }

}