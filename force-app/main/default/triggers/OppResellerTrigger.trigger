/**In Urla shoes as we are manufacturer of shoes, we have orders coming from our resellers and we want to know how many of these opportunities comes from which reseller.

So we need to have opportunity object and Reseller custom object
Then each time an opportunity is created the trigger will look at the reseller email in opportunity and compare with reseller object company emails and if it matches the  reseller lookup field in opportunity will be populated */


// Step 2 - EmailService1Handler classinda Opportunity tetikleniyor 
trigger OppResellerTrigger on Opportunity (before insert, before update, after insert, after update, before delete) {
   // OppResellerTriggerHandler.callReseller(trigger.new);

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //OpportunityTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            //OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } 
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //OpportunityTriggerHandler.afterInsert(Trigger.new);
          //Erdem Hoca ile yaptigimiz ==>  NewReseller.emailToReseller(trigger.new);
            EmelNewResellerYenidenCalisma.checkEmailsReseller(trigger.new);
          

        } else if (Trigger.isUpdate) {
            //OpportunityTriggerHandler.afterUpdateOppSync(Trigger.new, Trigger.oldMap);
           
        } else if (Trigger.isDelete) {
            //OpportunityTriggerHandler.afterDelete(Trigger.old);
        }
    }
   
    
    
}