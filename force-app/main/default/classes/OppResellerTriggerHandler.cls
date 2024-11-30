/**
 * Calculates Internal Rate of Return for a list of irregular cashflows.
 * Uses Newton's method to approximate solution to a target error level.
 *
 * Usage:
 * 
 *     XIRR myXIRR = new XIRR();
 *     myXIRR.addCashflow(Date.newInstance(2012, 1, 1), 1500.0);
 *     myXIRR.addCashflow(Date.newInstance(2012, 2, 15), -500.0);
 *     myXIRR.addCashflow(Date.newInstance(2012, 3, 7), -1000.0);
 *     try {
 *         System.debug(myXIRR.calculate());
 *     } catch(XIRR.XIRRException e) {
 *         ApexPages.addMessage(e);
 *     }
 *   Output: 
 * @author:      Luke McFarlane
 * @date:        Aug 2012
 * @testclass:   TestXIRR.cls
 */

public with sharing class OppResellerTriggerHandler {
    public static void callReseller(List<Opportunity> opps){
    Set<String> resellerEmails = new Set<String>();
    for (Opportunity opp : opps) {
        if (opp.Reseller_Email__c != null) {
            resellerEmails.add(opp.Reseller_Email__c);
        }
    }
    
    // Map to hold reseller email to reseller Id
    Map<String, Id> emailToResellerIdMap = new Map<String, Id>();
    
    // Query all Resellers with matching emails
    if (resellerEmails.size() > 0) {
        for (Reseller__c reseller : [SELECT Id, Email__c FROM Reseller__c WHERE Email__c IN :resellerEmails]) {
            emailToResellerIdMap.put(reseller.Email__c, reseller.Id);
        }
    }
    
    // Loop through Opportunities and assign the Reseller lookup field
    for (Opportunity opp : opps) {
        if (opp.Reseller_Email__c != null && emailToResellerIdMap.containsKey(opp.Reseller_Email__c)) {
            opp.Reseller__c = emailToResellerIdMap.get(opp.Reseller_Email__c);
        }
    }
}
}