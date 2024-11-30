import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import RESELLER_STATUS_FIELD from '@salesforce/schema/Reseller__c.Reseller_Status__c';
import RESELLER_FIELD from '@salesforce/schema/Opportunity.Reseller__c';

export default class ResellerStatusIcon extends LightningElement {
    @api recordId; // Opportunity record Id
    resellerStatus = false;

    @wire(getRecord, { recordId: '$recordId', fields: [RESELLER_FIELD] })
    opportunity;

    // Get the reseller's status field dynamically when the opportunity's reseller changes
    @wire(getRecord, { recordId: '$opportunity.data.fields.Reseller__c.value', fields: [RESELLER_STATUS_FIELD] })
    reseller({ error, data }) {
        if (data) {
            this.resellerStatus = data.fields.Reseller_Status__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}