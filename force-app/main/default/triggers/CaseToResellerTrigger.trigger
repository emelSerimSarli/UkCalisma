trigger CaseToResellerTrigger on Case (after insert) {
    // Sadece trigger'ın CaseHandler class'ını çağırması
    CaseHandler.createResellerRecords(Trigger.new);
}