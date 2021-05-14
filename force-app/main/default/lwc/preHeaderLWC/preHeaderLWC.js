import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class PreHeaderLWC extends NavigationMixin(LightningElement) {
    navigateToWebPage() {
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "/sba-loans/"
            }
        });
    }
}