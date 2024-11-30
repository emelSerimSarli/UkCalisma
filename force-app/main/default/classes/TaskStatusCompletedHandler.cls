public class taskStatusCompletedHandler {
   
        public static void updateOpportunityFields(List<Task> newTasks, List <Task> oldTaskMap) {
            Set<Id> opportunityIds = new Set<Id>();
    
            // Collect Opportunity IDs related to the affected Tasks
            if(newTasks!=null){
            for (Task task : newTasks) {
                if (task.WhatId != null && task.WhatId.getSObjectType() == Opportunity.sObjectType) {
                    opportunityIds.add(task.WhatId);
                }
            }}
            if(oldTaskMap!=null){
            for (Task task : oldTaskMap) {
                if (task.WhatId != null && task.WhatId.getSObjectType() == Opportunity.sObjectType) {
                    opportunityIds.add(task.WhatId);
                }
            }}
    
            // Update Opportunity fields based on the collected Opportunity IDs
            if (!opportunityIds.isEmpty()) {
                Opportunity[] oppUpdate = new Opportunity[]{};
                List<Opportunity> opportunitiesToUpdate = [SELECT Id, Completed_Task__c, Score__c, 
                                                           (SELECT Id, Status, Task_score__c FROM Tasks WHERE Status = 'Completed') 
                                                           FROM Opportunity WHERE Id IN :opportunityIds];
                system.debug('LISTE: ' + opportunitiesToUpdate);
                if(!opportunitiesToUpdate.isEmpty()){
                for (Opportunity opp : opportunitiesToUpdate) {
                    Integer completedTaskCount = 0;
                    Decimal totalScore = 0;
    
                    for (Task task : opp.Tasks) {
                        if (task.Status == 'Completed') {
                            completedTaskCount++;
                            totalScore += task.Task_score__c;
                        }
                    }
    
                    opp.Completed_Task__c = completedTaskCount;
                    opp.Score__c = totalScore;
                    oppUpdate.add(opp);
                }}
    
                update oppUpdate;
            }
        }
    }