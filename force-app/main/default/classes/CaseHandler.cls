public class CaseHandler {
    /*
Date    : 15/9/2024
Author  : Emel Sarli 
Purpose : When an e-mail comes to the system, create a new automatic reseller record.

    */
    // Created reseller 
    public static void createResellerRecords(List<Case> caseList) {
        List<Reseller__c> newResellers = new List<Reseller__c>();
        //List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Case cc : caseList) {
            // Sadece Email-to-Case kayıtları üzerinde işlem yapın
            // Supplied email keeps the senders emails.
            if (cc.Origin == 'Email' && cc.SuppliedEmail != null) {
                // Reseller kaydı oluşturma
                Reseller__c reseller = new Reseller__c();
                reseller.Email__c = cc.SuppliedEmail;
                reseller.Name = 'Reseller from Case ' + cc.CaseNumber;
                //reseller.Description__c = c.Description;
                newResellers.add(reseller);

                // Automatic send an eamil to the sender
               /* Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { c.SuppliedEmail });
                email.setSubject('Thank you for contacting us!');
                email.setPlainTextBody('We have received your inquiry and created a reseller record.');
                emails.add(email);*/
            }
        }

        if (!newResellers.isEmpty()) {
            
            insert newResellers;

            // Reply with an automatic email
           // Messaging.sendEmail(emails);
        }
    }
}