/*
date   : 09/28/2024
author : Emel Sarli
purpose:When a Reseller is created,  Reseller field in the Opportunity object to update the name field ,created in the Reseller object.
 */
public class ResellerHandler {
    public static void updateOpportunitiesWithReseller(List<Reseller__c> newResellers) {
        // Create a set to store unique Reseller emails
        Set<String> resellerEmails = new Set<String>();

        // Collect emails from all new Reseller records
        for (Reseller__c reseller : newResellers) {
            if (reseller.Email__c != null) {
                resellerEmails.add(reseller.Email__c);
            }
        }

        // Query all Opportunity records where Reseller_Email__c matches the emails
        List<Opportunity> relatedOpps = [SELECT Id, Reseller__c, Reseller_Email__c
                                         FROM Opportunity
                                         WHERE Reseller_Email__c IN :resellerEmails];

        // Prepare a map for quick lookup of Reseller by email
        Map<String, Id> resellerEmailToIdMap = new Map<String, Id>();
        for (Reseller__c reseller : newResellers) {
            resellerEmailToIdMap.put(reseller.Email__c, reseller.Id);
        }

        // List to store Opportunities to be updated
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        // Iterate over the Opportunity records and update the Reseller__c field
        for (Opportunity opp : relatedOpps) {
            if (resellerEmailToIdMap.containsKey(opp.Reseller_Email__c)) {
                opp.Reseller__c = resellerEmailToIdMap.get(opp.Reseller_Email__c);
                oppsToUpdate.add(opp);
            }
        }

        // Update Opportunities if there are any to update
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }
}