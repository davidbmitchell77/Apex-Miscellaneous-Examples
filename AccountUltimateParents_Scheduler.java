public class AccountUltimateParents_Scheduler implements System.Schedulable {

    public final Integer batchSize;

    public AccountUltimateParents_Scheduler() {
        this.batchSize = 200;
    }

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new AccountUltimateParents_Batch(), batchSize);
    }
}