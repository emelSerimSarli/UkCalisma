public with sharing class OpportunityAutoCloseBatch implements Database.Batchable<SObject>, Database.Stateful {

    // Query Opportunities in "Negotiation/Review" stage older than 60 days
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date targetDate = Date.today().addDays(-60);
        return Database.getQueryLocator(
            [SELECT Id, Name, StageName, CloseDate, OwnerId, Account.Name 
             FROM Opportunity 
             WHERE StageName = 'Negotiation/Review' 
             AND CloseDate <= :targetDate]
        );
    }

    // Update opportunities and send an email for each owner
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> ownerIds = new Set<Id>();

        for(Opportunity opp : oppList){
            ownerIds.add(opp.OwnerId);
        }
        Map<Id, User> ownerMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :ownerIds]);


        for (Opportunity opp : oppList) {
            
            opp.StageName = 'Closed Lost';
            opp.CloseDate = Date.today();
            oppsToUpdate.add(opp);

          

            User owner = ownerMap.get(opp.OwnerId);
           
                String emailBody = 'Hello, The following opportunity has been automatically closed as "Closed Lost":' +
                                   'Opportunity Name: ' + opp.Name + 
                                   ' Account Name: ' + opp.Account.Name + 
                                   ' Original Close Date: ' + opp.CloseDate + 
                                   ' Best regards,';

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{owner.Email});
                email.setSubject('Opportunity Auto Closed ');
                email.setPlainTextBody(emailBody);
                emails.add(email);
            
        }

        // Update all opportunities in bulk
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }

        // Send all emails in bulk
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    // Finish method can be empty if no further actions are needed after batch processing
    public void finish(Database.BatchableContext bc) {
        System.debug('OpportunityAutoCloseBatch finished processing.');
    }
}