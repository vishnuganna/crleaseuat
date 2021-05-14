import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import signaturePadURL from '@salesforce/resourceUrl/signature_pad';

export default class Signaturelwc extends LightningElement {
    sigPadInitialized = false;
    canvasWidth = 400;
    canvasHeight = 200;
    @api signatureString;
    @api displaySignature=false;
    renderedCallback() {
        if (this.sigPadInitialized) {
            return;
        }
        this.sigPadInitialized = true;

        Promise.all([
            loadScript(this, signaturePadURL)
        ])
            .then(() => {
                this.initialize();
            })
            .catch(error => {
                console.log(error);
            });
    }

    initialize() {
        const canvas = this.template.querySelector('canvas.signature-pad');
        this.signaturePad = new window.SignaturePad(canvas);
    }
    @api handleSignature(){ 
      return this.signaturePad.toDataURL().replace(/^data:image\/(png|jpg);base64,/, "");
    }
    onSignatureAgree(){
        this.signatureString=this.signaturePad.toDataURL().replace(/^data:image\/(png|jpg);base64,/, "");
    }
    clearSignatureOnClick(){
        this.signaturePad.clear();
    }
}