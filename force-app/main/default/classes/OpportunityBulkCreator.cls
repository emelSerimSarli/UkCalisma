/*
Date    : 11/14/2024
Author  : Erdem AYDIN
Purpose : This Class creates Opportunities as much as given number.
        
*/


public with sharing class OpportunityBulkCreator {

    private static List<String> stageNames = new List<String>{
        'Prospecting', 
        'Qualification', 
        'Needs Analysis', 
        'Value Proposition', 
        'Id. Decision Makers', 
        'Perception Analysis', 
        'Proposal/Price Quote', 
        'Negotiation/Review', 
        'Closed Won', 
        'Closed Lost'
    };


    public static void createOpportunities (Integer recordCount) {
        Opportunity[] opps = new Opportunity[]{};
        for (Integer i = 0; i < recordCount; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Ferzan Hoca\'s Opportunities '+i,
                StageName = getRandomStageName(),
                CloseDate = Date.today().addMonths(1),
                Reseller__c = getRandomRS().Id
            );
            opps.add(opp);
        }
        if (!opps.isEmpty()) {
            insert opps;
        }
    }

    // This method helps us to select stage name randomly;
    private static String getRandomStageName() {
        Integer randomSnIndex = Math.floor(Math.random() * stageNames.size()).intValue(); 
        return stageNames[randomSnIndex];
    }

    private static Reseller__c[] rs = [SELECT Id, Name FROM Reseller__c Limit 10];
    private static Reseller__c getRandomRS() {
        Integer randomRsIndex = Math.floor(Math.random() * rs.size()).intValue();
        return rs[randomRsIndex];
    }
}

/*

    Opportunity[] deleteOpps = [SELECT Id, Name FROM Opportunity WHERE Name LIKE '%Ferza%'];
    delete deleteOpps;

    OpportunityBulkCreator.createOpportunities(200);


*/