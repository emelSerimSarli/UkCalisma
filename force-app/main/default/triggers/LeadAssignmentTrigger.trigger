trigger LeadAssignmentTrigger on Lead (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        LeadAssignmentHandler.handleLeadAssignment(Trigger.new);
    }
}