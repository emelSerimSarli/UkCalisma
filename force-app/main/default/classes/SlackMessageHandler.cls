/*
Date   : 9/21/2024
Author : Emel Sarli
Purpose: Write a trigger for opporutnity;
if amount changes more than %20 plus or minus. sent a slack message, show opportunity name, amount and stage.
so its also integration and we need to use Future Callout  chacable = true */




public class SlackMessageHandler {
    private static final String slackWebhookUrl = 'https://hooks.slack.com/services/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';

    @future(callout=true)
    public static void sendSlackMessage(String opportunityName, Decimal oldAmount, Decimal newAmount) {
      
        String message = '{"text": "Opportunity: ' + opportunityName + 
                         ' has changed its amount by more than 20%! Old Amount: ' + 
                         oldAmount + ', New Amount: ' + newAmount + '"}';

       
        HttpRequest req = new HttpRequest();
        req.setEndpoint(slackWebhookUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(message);

       
        Http http = new Http();
        try {
           
            HttpResponse res = http.send(req);

            if (res.getStatusCode() != 200) {
                System.debug('Slack mesajı gönderilemedi: ' + res.getBody());
            } else {
                System.debug('Slack mesajı başarıyla gönderildi: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Slack mesajı gönderim hatası: ' + e.getMessage());
        }
    }
}