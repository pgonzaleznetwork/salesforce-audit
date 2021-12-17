import { LightningElement, api, wire } from 'lwc';
import getText from '@salesforce/apex/SRM_MetadataConflictWarningController.getText';

export default class SRM_MetadataConflictLWC extends LightningElement {

    @api recordId;

    @wire(getText, { deploymentId: '$recordId' })
    result;

    get hasConflicts(){
        return this.result.data.conflicts;
    }

    get warning(){
        return this.result.data.warning;
    }
}