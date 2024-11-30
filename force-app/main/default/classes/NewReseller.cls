/*
Date    : 09/16/2024
Purpose : When an opportunity is crated, our trigger check if reseller matches. 
          If not an email will be send to the reseller saying that we received your order but your are not registered!
          Please reply to register and the response should go to salesforce incoming emails. 
          Additionally, your email response should create reseller record, and the  email body should contains reseller name, phone and email.
Author  : Erdem AYDIN
*/
// Step 3 OppResellerTrigger ' den sonra bu class calisiyor ve Opportunity nin parentina bagli bir email var mi check edip 
// yoksa ona gerekli bilgileri doldurmasi gereken bir email gonderiyor'
public with sharing class NewReseller {
    //kendi yaptigim metodun ismi 'checkEmailsReseller' y
    public static void emailToReseller(List<Opportunity> newOppList) {

        // Map to store Reseller Emails to IDs
        Map<String, Id> resellerEmailMap = new Map<String, Id>();
        for (Reseller__c rs : [SELECT Id, Email__c FROM Reseller__c WHERE Email__c != NULL]) {
            resellerEmailMap.put(rs.Email__c, rs.Id);
        }
        System.debug('Reseller map calisiyor ' + resellerEmailMap);

        // Collect Owner IDs
       /* Set<Id> ownerIds = new Set<Id>();
        for (Opportunity opp : newOppList) {
            if (opp.OwnerId != null) {
                ownerIds.add(opp.OwnerId);
            }
        }

        // Query User records for Opportunity Owners
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :ownerIds]);
*/
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
        //List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        

        for (Opportunity opp : newOppList) {
            if (opp.Reseller_Email__c != NULL && resellerEmailMap.containsKey(opp.Reseller_Email__c)) {
                opp.Reseller__c = resellerEmailMap.get(opp.Reseller_Email__c);
                //opportunitiesToUpdate.add(opp);
            } else {

                // Construct email body for each Opportunity
                String emailBody = 'Dear Customer, \n\n';
                emailBody += 'We have received your order and created the following Opportunity:\n\n';
                emailBody += 'Opportunity Name: ' + opp.Name + '\n';
                emailBody += 'Account Id: ' + opp.AccountId + '\n\n';
                emailBody += 'Unfortunately, you are not registered in our system.\n\n';
                emailBody += 'Please fill out the attachment and reply to this email with your name, phone number to complete the registration process.\n\n';
                emailBody += 'Best regards, \nErdem, \nSalesforce Team';

                System.debug('Email body = ' +emailBody);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{opp.Reseller_Email__c});//??
                System.debug('Email = ' +email);
                // Set CC to Opportunity Owner
                // User oppOwner = userMap.get(opp.OwnerId);
                // if (oppOwner != null) {
                //     email.setCcAddresses(new List<String>{oppOwner.Email});
                // }
                
                // burada Reseller gonderdigimiz email olustuyor.Resellerin gondermesini istedigimiz email adresini assign ediyoruz
                // Boylece diger email servise ve ona bagli class calisip yeni bir reseller insert edilsin
                
                email.setReplyTo('email_service_2@ed30qu3klnkmcwmi3qgebo1q8rqkmumg8pn8vg7ce8u8zcyva.qy-8tzi1mak.swe42.apex.salesforce.com');
                
                //email.setReferences(opp.Reseller_Email_Id__c);

                //gelen emailin subjecti onmeli thread icin
                email.setSubject(opp.Email_Service_One_Subject__c);

                email.setPlainTextBody(emailBody);
                //email.setSaveAsActivity(true);

                // Generate Opportunity-specific attachment
                String attachmentContent = generateAttachmentContent(opp);
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('ResellerDetails.txt');
                attachment.setBody(Blob.valueOf(attachmentContent));
                attachment.setContentType('text/plain');
                email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

                emails.add(email);

            }
        }

        // Update Opportunities with assigned Reseller__c
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
            System.debug('Updated Opportunities with Reseller__c: ' + opportunitiesToUpdate.size());
        }

        // Send emails
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
            System.debug('Emails sent: ' + emails.size());
        }
    }

    // Helper method to generate Opportunity-specific attachment content
    public static String generateAttachmentContent(Opportunity opp) {
        String attachmentContent = 'Reseller Details\n';
        attachmentContent += '--------------------\n';
        attachmentContent += 'Opportunity Name: ' + opp.Name + '\n';
        attachmentContent += 'Account Id: ' + opp.AccountId + '\n';
        attachmentContent += 'Reseller Name  : \n';
        attachmentContent += 'Reseller Phone : \n';
        attachmentContent += 'Reseller Email : \n';
       System.debug(  'email attachment'+attachmentContent);
        // return 'Opportunity Name: ' + opp.Name + '\n';
        return attachmentContent;
    }
}