import { LightningElement,track } from 'lwc';
// importing resource loader
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
// imported for to show toast messages
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PodiumWebchatLWC extends LightningElement {
    @track error;
    @track successMessage = '';
    renderedCallback() {
        Promise.all([
        loadScript(this, 'https://connect.podium.com/widget.js#API_TOKEN=1dec4e9b-2f57-4c10-9c1d-2ca18375f793')
    ]).then(() => { 
            // Call back function if scripts loaded successfully
            this.showSuccessMessage();
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: this.error,
                    variant: 'error',
                }),
            );
        });
       
    }
  
    
    showSuccessMessage() { // call back method 
       this.successMessage = 'Scripts are loaded successfully!!';
       alert('Scripts are loaded successfully!!!');
    }
}