public  class ScheduleOpportunityAutoCloseBatch implements Schedulable{
    public void execute(SchedulableContext sc) {
        OpportunityAutoCloseBatch batch = new OpportunityAutoCloseBatch();
        Database.executeBatch(batch);
   }
}