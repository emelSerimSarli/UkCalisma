trigger QuoteTrigger on Quote (after insert) {
for (Quote q : Trigger.new) {
        QuotePDFService.generateAndAttachPDF(q.Id);
        system.debug('yeni quote olustu');
    }
}