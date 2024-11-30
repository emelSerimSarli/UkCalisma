import { LightningElement } from 'lwc';

export default class GettersInLWC extends LightningElement {
    number1 = 12;
    number2 = 14;

    fruits = ["Elma", "Armut" , "Muz"];

    get sumNumber(){
        return this.number1 + this.number2;
    }
    get firstFruit(){
        return this.fruits[0];
    }

}