public with sharing class QuotePDFController {
     public Quote quote { get; set; }

    /*public QuotePDFController() {
        Id quoteId = ApexPages.currentPage().getParameters().get('id');
        if (quoteId != null) {
            this.quote = [SELECT Id , Name ,Status ,ExpirationDate ,Email , Opportunity.Name ,TotalPrice FROM Quote WHERE Id = :quoteId];
        }
    }*/
}