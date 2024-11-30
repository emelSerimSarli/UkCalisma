global with sharing class EmelEmailThreadForResellerYeniden implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        try {
            // Check if the email has binary attachments
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                System.debug('Attachments found. Processing...');
                //***Go to your email services on your org and configure both 'Accept Attachments' and 'Convert Text Attachments to Binary Attachments' options. (All & True-Check)
                for (Messaging.InboundEmail.BinaryAttachment attachment : email.binaryAttachments) { 
                    System.debug('Attachment found: ' + attachment.fileName);

                    // Add a null check to ensure attachment.body is not null
                    if (attachment.body != null) {
                        // Check if it's a .txt file
                        if (attachment.fileName.endsWith('.txt')) {
                            String attachmentContent = attachment.body.toString();
                            System.debug('Attachment content: ' + attachmentContent);

                            Map<String, String> resellerDetails = parseAttachmentContent(attachmentContent);

                            // Check if we successfully parsed the attachment and have reseller details
                            if (resellerDetails != null && !resellerDetails.isEmpty()) {
                                Reseller__c newReseller = new Reseller__c(
                                    Name = resellerDetails.get('Reseller Name'),
                                    Phone__c = resellerDetails.get('Reseller Phone'),
                                    Email__c = resellerDetails.get('Reseller Email'),
                                    //Email_Service_Id__c = email.messageId,
                                    Email_Service_Two__c = email.subject
                                );
                                insert newReseller;
                                System.debug('New reseller created: ' + newReseller);

                                //**** Query for any existing Opportunities with matching email
                                List<Opportunity> oppsToUpdate = [SELECT Id FROM Opportunity WHERE Reseller_Email__c = :newReseller.Email__c AND Reseller__c = NULL];
                                for (Opportunity opp : oppsToUpdate) {
                                    opp.Reseller__c = newReseller.Id;
                                }
                                
                                if (!oppsToUpdate.isEmpty()) {
                                    update oppsToUpdate;
                                    System.debug('Updated Opportunities with new Reseller');
                                }

                            } else {
                                System.debug('Failed to parse reseller details from the attachment.');
                            }
                        } else {
                            System.debug('Attachment is not a .txt file. Skipping...');
                        }
                    } else {
                        System.debug('Attachment body is null.');
                    }
                }
            } else {
                System.debug('No binary attachments found in the email.');
            }
        } catch (Exception e) {
            System.debug('Error processing email: ' + e.getMessage());
            result.success = false;
            return result;
        }

        result.success = true;
        return result;
    }

    // Helper method to parse the attachment content
    private Map<String, String> parseAttachmentContent(String attachmentContent) {
        Map<String, String> resellerDetails = new Map<String, String>();

        try {
            // Split the content by line breaks
            List<String> lines = attachmentContent.split('\n');

            // Assume the format is like:
            // Reseller Name  : <name>
            // Reseller Phone : <phone>
            // Reseller Email : <email>

            for (String line : lines) {
                if (line.contains('Reseller Name')) {
                    resellerDetails.put('Reseller Name', line.split(':')[1].trim());
                } else if (line.contains('Reseller Phone')) {
                    resellerDetails.put('Reseller Phone', line.split(':')[1].trim());
                } else if (line.contains('Reseller Email')) {
                    resellerDetails.put('Reseller Email', line.split(':')[1].trim());
                }
            }

            System.debug('Parsed reseller details: ' + resellerDetails);

        } catch (Exception e) {
            System.debug('Error parsing attachment content: ' + e.getMessage());
            return null;
        }

        return resellerDetails;
    }
}