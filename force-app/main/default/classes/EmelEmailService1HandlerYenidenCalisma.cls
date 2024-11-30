/** Step 1
 * 
 * Disardeki bir clientten(reseller) salesforce a (email webservice) ine email geldiginde olusacak bir opportunity create ediyoruz.
 * webservice i icin de bir class gerekli
 * Bu web  service i ne yapiyor???
        *  3rd party den bizim orgumuza email gelmesi icin bir email adresi lazim. 
        *  bu web servisinin calisabilmesi icin bir inbound class olusturmak gerekiyor

 */
global with sharing class EmelEmailService1HandlerYenidenCalisma implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail (Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        try{
            Opportunity opp = new Opportunity();
            opp.Name = email.fromName;
            opp.StageName = 'Prospecting';
            opp.closeDate = Date.Today().addMonths(30);
            opp.Reseller_Email__c = envelope.fromAddress;
            opp.Email_Service_One_Subject__c = email.subject;
            insert opp;
        }
        catch(Exception e){
            System.debug('Error Processing Email : ' + e.getMessage());
            result.success = false;
            return result;
    }
    result.success = true;
    return result;
    
}
}