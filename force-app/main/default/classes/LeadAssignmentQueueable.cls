public class LeadAssignmentQueueable implements Queueable {
    private List<Id> leadIds;

    public LeadAssignmentQueueable(List<Id> leadIds) {
        this.leadIds = leadIds;
    }

    public void execute(QueueableContext context) {
        Id activeRepId = ShiftAssignmentHelper.getActiveShiftRepresentative();
        if (activeRepId != null) {
            List<Lead> leadsToUpdate = [SELECT Id,Representative__c FROM Lead WHERE Id IN :leadIds];
            for (Lead lead : leadsToUpdate) {
                lead.Representative__c= activeRepId;
            }
            update leadsToUpdate;
        }
    }
}