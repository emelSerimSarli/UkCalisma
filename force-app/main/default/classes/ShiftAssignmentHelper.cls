public class ShiftAssignmentHelper {
    public static Id getActiveShiftRepresentative() {
        // Current date and time
        Datetime currentnow = Datetime.now();
       


        // Query to get the active shift with the earliest start time
        List<Shift> activeShifts = [
            SELECT Representative__c 
            FROM Shift
            WHERE StartTime <= :currentnow 
            AND EndTime >= :currentnow
            ORDER BY StartTime ASC
            LIMIT 1
        ];

        if (!activeShifts.isEmpty()) {
            return activeShifts[0].Representative__c;
        } else {
            return null;
        }
    }
}