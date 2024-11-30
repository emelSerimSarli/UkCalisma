public class OpportunityTriggerHandler {
   /* public static void beforeInsert(List<Opportunity> newOpps) {
        
    }
    
    public static void beforeUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
    }

    public static void afterInsert(List<Opportunity> newOpps) {
        
    }*/

    public static void afterUpdateOppSync(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        //written by    = Emel Sarli
        //purpose       = Create a new loan record whenever we have a Closed - Won Opportunity
        //               Verify the isSynced field on the Loan record by making a callout to the company's core systems.
        //               Send the Loan info in a JSON format 
        //URL           = https://putsreq.com/QAcQ4r2IDSmcRrmLQElb
        //Protokol      = https://
        // Domain       = https://putsreq.com
        // Path         = /QAcQ4r2IDSmcRrmLQElb
        // Method       = POST
        // Headers      = Content-Type: application/json
        // Body         = { "sf_id": "00Q2C0000045ZZZ", "amount": 100, "term":  , "monthly_payments": null }
        


        List<Loan__c> loansToInsert = new List<Loan__c>();

        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                Loan__c loan = new Loan__c();
                loan.Opportunity__c= opp.Id;
                loan.Amount__c = opp.Amount;
                loan.Terms__c= opp.Terms__c; 
                loan.Monthly_Payment__c = (opp.Amount != null && opp.Terms__c != null) ? opp.Amount / opp.Terms__c : 0;
                loansToInsert.add(loan);
            }
        }

        if (!loansToInsert.isEmpty()) {
            insert loansToInsert;
            List<Id> loanIds = new List<Id>();
            for (Loan__c loan : loansToInsert) {
                loanIds.add(loan.Id);
            }
            syncLoans(loanIds);
        }
    }

   // public static void afterDelete(List<Opportunity> oldOpps) {
    //}

    @future(callout=true)
    private static void syncLoans(List<Id> loanIds) {
        List<Loan__c> loansToUpdate = [SELECT Id, Amount__c, Terms__c, Monthly_Payment__c FROM Loan__c WHERE Id IN :loanIds];
        string path = '/QAcQ4r2IDSmcRrmLQElb';
        for (Loan__c loan : loansToUpdate) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:PutsReq_API1'+path); 
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            
            Map<String, Object> loanMap = new Map<String, Object>();
            loanMap.put('sf_id', loan.Id);
            loanMap.put('loan_amount', loan.Amount__c);
            loanMap.put('term_in_months', loan.Terms__c);
            loanMap.put('monthly_payments', loan.Monthly_Payment__c);
            
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('Loan', loanMap);
            
            String jsonBody = JSON.serialize(requestBody);
            System.debug('JSON Body: ' + jsonBody); 
            req.setBody(jsonBody);
            req.setBody(JSON.serialize(requestBody));
            
            Http http = new Http();
            HttpResponse res;
          
           
            try {
                res = http.send(req);
                if (res.getStatusCode() == 200) {
                    loan.isSynced__c = true;
                } else {
                    loan.isSynced__c = false;
                }
            } catch (Exception e) {
                loan.isSynced__c = false;
                System.debug('isSynced ? ');
                System.debug(e.getMessage() + ' Error line = '+ e.getLineNumber());
            }
            
            
        }

        if (!loansToUpdate.isEmpty()) {
            update loansToUpdate;
        }
    }
}