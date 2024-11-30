trigger ResellerTrigger on Reseller__c (before insert, after insert, before update, after update) {
    if (trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        ResellerTriggerHandler.emailToReseller(trigger.new);
        //ResellerHandler.updateOpportunitiesWithReseller(Trigger.new);
  }
}