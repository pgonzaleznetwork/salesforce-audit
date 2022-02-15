import { LightningElement } from 'lwc';
import sayHi from '@salesforce/apex/SaltoUIController.sayHi';

export default class saltoUI extends LightningElement {

    message = 'default';
    error =  null;

    handleLoad() {
        sayHi()
            .then(result => {
                this.message = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

}