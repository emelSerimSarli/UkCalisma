//Re-Coaching Second Week
trigger taskStatusCompleted on Task (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate|| Trigger.isDelete ){
            taskStatusCompletedHandler.updateOpportunityFields(Trigger.new, Trigger.old);
        }
       
    }
}