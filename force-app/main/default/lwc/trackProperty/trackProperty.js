import { LightningElement, track } from 'lwc';

export default class TrackProperty extends LightningElement {
   @track location = {
        city:"London",
        country:"UK",
        postalCode:'nwp'

    }
    changeHandler(event){
        this.location.city = event.target.value;
    }
}