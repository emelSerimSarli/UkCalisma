public class QuotePDFService {
    @future(callout=true)
    public static void generateAndAttachPDF(Id quoteId) {
       
        Quote quote = [SELECT Id , Name ,Status ,ExpirationDate ,Email , Opportunity.Name , TotalPrice FROM Quote WHERE Id = :quoteId];

        PageReference pdfPage = Page.QuoteRender; 
        pdfPage.getParameters().put('id',quoteId);
        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            System.debug('Failed to generate PDF: ' + e.getMessage());
            return;
        }

        // PDF'yi oluştur ve Quote'a ekle
        Attachment pdfAttachment = new Attachment();
        pdfAttachment.ParentId = quoteId;
        pdfAttachment.Name = quote.Name + '.pdf';
        pdfAttachment.Body = pdfBlob;
        pdfAttachment.ContentType = 'application/pdf';
        insert pdfAttachment;
    }
}