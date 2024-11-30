public class LeadAssignmentHandler {
    public static void handleLeadAssignment(List<Lead> newLeads) {
        List<Id> leadIds = new List<Id>();
        for (Lead lead : newLeads) {
            leadIds.add(lead.Id);
        }
        if (!leadIds.isEmpty()) {
            System.enqueueJob(new LeadAssignmentQueueable(leadIds));
        }
    }
}