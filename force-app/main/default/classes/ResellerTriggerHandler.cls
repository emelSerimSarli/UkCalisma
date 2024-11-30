/*
Date    : 09/28/2024
Author  : Emel Sarli
Purpose : Our class sending e-mail after Reseller records inserted to notify the resellers that their account registered successfully. 
*/

/*public with sharing class ResellerTriggerHandler {
    public static void emailToReseller(Reseller__c[] rsList) {
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
        String emailBody = 'Dear Customer, \nYou have been registered successfully. Please see the information below.';
        
        if (!rsList.isEmpty()) {

            System.debug('Reseller records inserted');

            for (Reseller__c rs : rsList) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setCcAddresses(new String []{rs.Email__c});
                //email.setBccAddresses(new String[]{[SELECT Email FROM USer WHERE Id = :rs.OwnerId].Email});
                emailBody += 'Reseller Name : ' + rs.Name + '\n';
                emailBody += 'Reseller Phone : ' + rs.Phone__c + '\n'; 
                emailBody += 'Reseller Email : ' + rs.Email__c + '\n';
                emailBody += 'Sincerely, \nEmel, \nSalesforce Developer';
                email.setSubject(rs.Email_Service_Two__c);
                email.setPlainTextBody(emailBody);
                email.setSaveAsActivity(true);
                emails.add(email);

                System.debug('Following e-mail created; \n ' + email);
            }
        }
        if (emails.size()>0) {
            Messaging.sendEmail(emails);
            System.debug('Emails are sent');
        }
    }
}*//*
Date    : 09/19/20224
Author  : Erdem AYDIN
Purpose : Our class sending e-mail after Reseller records inserted to notify the resellers that their account registered successfully. 
*/

public with sharing class ResellerTriggerHandler {
    public static void emailToReseller(Reseller__c[] rsList) {
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
        String emailBody = 'Dear Customer, \nYour Account has been registered successfully. Please see the information below.';
        
        if (!rsList.isEmpty()) {

            System.debug('Reseller records inserted');

            //Opportunity[] newOpps = new Opportunity[]{};

            for (Reseller__c rs : rsList) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setCcAddresses(new String []{rs.Email__c, 'erdemaydinlarusa@gmail.com'});
                //email.setBccAddresses(new String[]{[SELECT Email FROM USer WHERE Id = :rs.OwnerId].Email});
                email.setToAddresses(new List<String>{[SELECT Email FROM USer WHERE Id = :rs.OwnerId].Email});//????????
                //email.setInReplyTo(rs.Email_Service_Id__c);
                emailBody += 'Reseller Name : ' + rs.Name + '\n';
                emailBody += 'Reseller Phone : ' + rs.Phone__c + '\n'; 
                emailBody += 'Reseller Email : ' + rs.Email__c + '\n';
                emailBody += 'Sincerely, \nEmel, \nSalesforce Developer';
                email.setSubject(rs.Email_Service_Two__c);
                email.setPlainTextBody(emailBody);
                email.setSaveAsActivity(true);
                emails.add(email);

                System.debug('Following e-mail created; \n ' + email);
            }
            // update newOpps;
        }
        if (emails.size()>0) {
            Messaging.sendEmail(emails);
            System.debug('Emails are sent');
        }
    }
    
    public static void updateOpportunities(Reseller__c[] rsList) {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
    
        // Fetch Reseller details and create a map of Reseller Ids to Reseller records
        Map<Id, Reseller__c> resellerMap = new Map<Id, Reseller__c>();
        for (Reseller__c rs : [SELECT Id, Email__c FROM Reseller__c WHERE Id IN :rsList]) {
            resellerMap.put(rs.Id, rs);
        }
    
        // Query Opportunities that are associated with the Resellers
        List<Opportunity> relatedOpps = [SELECT Id, Reseller__c FROM Opportunity WHERE Reseller__c IN :resellerMap.keySet()];
    
        for (Opportunity opp : relatedOpps) {
            // Fetch the Reseller record from the map
            Reseller__c reseller = resellerMap.get(opp.Reseller__c);
            if (reseller != null) {
                opp.Reseller_Email__c = reseller.Email__c; // Set the Reseller's email on the Opportunity
                oppsToUpdate.add(opp);
            }
        }
    
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
            System.debug('Updated Opportunities with new Reseller');
        }
    }
}