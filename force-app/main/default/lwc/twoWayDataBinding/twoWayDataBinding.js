import { LightningElement } from 'lwc';

export default class TwoWayDataBinding extends LightningElement {
    fullName='Emel Sarli';
    course = 'Calisma';
    changeHandler(event){
        this.course = event.target.value;
    }

}