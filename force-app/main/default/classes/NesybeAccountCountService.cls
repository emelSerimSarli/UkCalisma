public with sharing class NesybeAccountCountService {
  
        @InvocableMethod(label='Get Account Count' description='Get the count of Account records from another Salesforce Org')
        public static List<Integer> getAccountCount(List<String> params) {
            List<Integer> accountCounts = new List<Integer>();
            
            try {
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:https://demsalesf-dev-ed.develop.my.salesforce.com/services/data/v58.0/query/?q=SELECT+COUNT()+FROM+Account');
                req.setMethod('GET');
    
                Http http = new Http();
                HttpResponse res = http.send(req);
    
                if (res.getStatusCode() == 200) {
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Integer accountCount = Integer.valueOf(responseMap.get('totalSize'));
                    accountCounts.add(accountCount);
                    System.debug('Account Count:' + accountCounts);
                } else {
                    accountCounts.add(0);
                }
            } catch(Exception e) {
                accountCounts.add(0);
            }
            
            return accountCounts;
        }
    }