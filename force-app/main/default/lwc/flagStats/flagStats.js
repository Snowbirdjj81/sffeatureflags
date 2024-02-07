import { LightningElement, wire, api } from 'lwc';
import getStats from '@salesforce/apex/FeatureFlagController.getFeatureStats';

export default class FlagStats extends LightningElement {
    loading = true;

    @api recordId;
    lastUsed = 0;
    onPercent = 0;
    useCount = 0;
    overridePercent = 0;

    @wire(getStats, { recordId: '$recordId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.useCount = data.useCount;
            this.lastUsed = data.lastUsed;
            this.onPercent = data.onPercent;
            this.overridePercent = data.overridePercent;
            this.error = undefined;
            this.loading = false;
        } else if (error) {
            console.error(error);
            this.error = error;
            this.record = undefined;
        }
    }

    get alwaysOn() {
        return this.onPercent == 1;
    }

    get alwaysOff() {
        return this.useCount > 0 && this.onPercent == 0
    }

}