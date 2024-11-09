public class AccountUltimateParents_Scheduler implements System.Schedulable {

    private final Integer batchSize;

    public AccountUltimateParents_Scheduler() {
        this.batchSize = 200;
    }

    public AccountUltimateParents_Scheduler(Integer i) {
        this.batchSize = i;
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new AccountUltimateParents_Batch(), batchSize);
    }
}
