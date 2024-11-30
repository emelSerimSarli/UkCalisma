ScheduleOpportunityAutoCloseBatch objA = new ScheduleOpportunityAutoCloseBatch();
String cronExpression = '0 58 12 8 9 ? 2024'; 
System.schedule('Weekly Opportunity Auto Close Batch', cronExpression, objA);
