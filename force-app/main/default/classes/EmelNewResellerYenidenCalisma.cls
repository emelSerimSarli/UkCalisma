public with sharing class EmelNewResellerYenidenCalisma {
    //neden parametre kullandik!!!!
    public static void checkEmailsReseller(List<Opportunity> newOpps){

        Map<String, Id> resellerHasEmailMap = new Map<String,Id>();///Neden map yaptik

        system.debug('Emaili null olmayan butun reseller emaillerini topladik');
        for(Reseller__c resel : [SELECT Id, Email__c FROM Reseller__c WHERE Email__c != NULL]){
            
                resellerHasEmailMap.put(resel.Email__c, resel.Id);
        }
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};///Neden Emails olusturduk
         List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        System.debug('Single email message calisti --line 16');

        for(Opportunity opp: newOpps){
            if (opp.Reseller_Email__c != NULL && resellerHasEmailMap.containsKey(opp.Reseller_Email__c)) {
                opp.Reseller__c = resellerHasEmailMap.get(opp.Reseller_Email__c);
                opportunitiesToUpdate.add(opp);
            } else {
                    String emailBody = 'Dear'+ '\n';
                    emailBody += '!!! We have received your order but You are not our customer !!! ' + '/n';
                    emailBody += ' Please firstly register our system which will have been sent in a file information below' +'/n/n/n/n';
                    emailBody += 'Thanks, ' + '\n';
                    emailBody += opp.CreatedById+ '/n';
                    emailBody += 'Best regards,';

                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new List<String>{opp.Reseller_Email__c});///NEDEN liste

                    email.setReplyTo('email_service_4_kendim@1j4qqbuxnd5judq7opqdzb0jqvwuorlkhhsktireslfsp8fuie.qy-8tzi1mak.swe42.apex.salesforce.com'); /////ONEMLI!!!!!
                    email.setSubject(opp.Email_Service_One_Subject__c);////ANLAMADIMMM
                    email.setPlainTextBody(emailBody);

                    String attachmentContent = generateAttachmentContent(opp);
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('ResellerDetails.txt');
                attachment.setBody(Blob.valueOf(attachmentContent));
                attachment.setContentType('text/plain');
                email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

                emails.add(email);




                
            }
            if (!opportunitiesToUpdate.isEmpty()) {
                update opportunitiesToUpdate;
                System.debug('Updated Opportunities with Reseller__c: ' + opportunitiesToUpdate.size());
            }
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
        System.debug('Emails sent: ' + emails.size());
    }
}
public static String generateAttachmentContent(Opportunity opp) {
    String attachmentContent = '!!! Please fill in the information below !!!\n\n';
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