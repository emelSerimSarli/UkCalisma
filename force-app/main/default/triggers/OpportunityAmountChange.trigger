trigger OpportunityAmountChange on Opportunity (before insert, before update, after insert, after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            // Ensure oldMap is not null and that Amount is set in both old and new records
            if (Trigger.oldMap != null && Trigger.oldMap.get(opp.Id) != null && opp.Amount != null) {
                Decimal oldAmount = Trigger.oldMap.get(opp.Id).Amount;
    
                // Check if oldAmount is not null (it may be null if it wasn't populated before)
                if (oldAmount != null) {
                    Decimal newAmount = opp.Amount;
    
                    // %20'lik bir değişiklik olup olmadığını kontrol edin
                    if (Math.abs(newAmount - oldAmount) >= oldAmount * 0.2) {
                        // Asenkron olarak SlackMessageHandler'ı kullanarak mesaj gönderin
                        SlackMessageHandler.sendSlackMessage(opp.Name, oldAmount, newAmount);
                    }
                }
            }
        }
    }

}