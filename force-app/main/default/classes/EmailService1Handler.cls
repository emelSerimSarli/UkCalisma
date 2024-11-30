// Step 1 Email service 1 calisiyor ve ilk adimda gelen emaile cevap olarak bir opp olusuyor

global with sharing class EmailService1Handler implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail (Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        System.debug('Inbound Email working');
        
        try {

            Opportunity newOpp = new Opportunity();
            newOpp.Name = email.fromName;
            newOpp.CloseDate = System.now().addDays(7).date();  // newOpp.CloseDate = Date.today().addMonths(1);
            newOpp.StageName = 'Prospecting'; 
            //newOpp.Reseller_Email_Id__c = email.messageId;
            // Email Tread needs a common subject for the email to be processed
            newOpp.Email_Service_One_Subject__c = email.subject;
            newOpp.Reseller_Email__c = envelope.fromAddress;
            insert newOpp;
           // System.debug('Message Id ' + newOpp.Reseller_Email_Id__c);
            System.debug('New Opportunity created: ' + newOpp);

        } catch (Exception e) {
            System.debug('Error Processing Email : ' + e.getMessage());
            result.success = false;
            return result;
        }
        result.success = true;
        return result;
    }
}