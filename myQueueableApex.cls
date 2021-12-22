public class myQueueableApex implements Queueable, Finalizer
{
    /*----------------------------------------------------------------------------*/
    /* @class         - myQueueableApex                                           */
    /* @date          - 20-DEC-2021                                               */
    /* @author        - David B. Mitchell (Infosys Limited)                       */
    /* @description   - Sample queueable with finalizer apex class.               */
    /*----------------------------------------------------------------------------*/
    public final Boolean all;
    public final Boolean allOrNone;

    private List<LogMessage__c> logMessages = new List<LogMessage__c>();

    public myQueueableApex()
    {
        all = false;
        allOrNone = true; 
    }

    public void execute(QueueableContext QC)
    {
        String jobId = String.valueof(QC.getJobId());

        System.debug('Begin: executing queueable job ' + jobId + '.');

        System.attachFinalizer(new myQueueableApex());

        myFinalizer.addLog(System.now(), 'About to do some work...', jobId);

        System.debug('Completed: execution of queueable job ' + jobId + '.');
    }

    public void execute(FinalizerContext FC)
    {
        String requestId = '' + FC.getRequestId();
        String parentJobId = '' + FC.getAsyncApexJobId();
        System.debug('Begin: executing finalizer attached to queueable job ' + parentJobId + '.');

        System.debug('Updating job id on ' + logMessages.size() + ' log message records...');
        for (LogMessage__c log : logMessages)
        {
            log.RequestId__c = requestId;
            log.ParentJobId__c = parentJobId;
        }
        System.debug('Log records updated.');

        System.debug('Committing log records to database...');
        Database.insert(logMessages, all);
        System.debug('Log records committed.');

        if (FC.getResult() == ParentJobResult.SUCCESS)
        {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
            System.debug('Enqueueing another instance of the queueable...');
            String newJobId = (!Test.isRunningTest() ? System.enqueueJob(new myQueueableApex()) : null); // This call fails after 5 retries.
            System.debug('Enqueued new job: ' + newJobId + '.');
        }
        else
        {
            System.debug('Parent queueable job [' + parentJobId + '] failed due to unhandled exception: ' + FC.getException().getMessage());
        }
 
        System.debug('Completed: execution of finalizer attached to queueable job: ' + parentJobId + '.');
    }

    public void addLog(Datetime logDate, String message, String source)
    {
        LogMessage__c lm = new LogMessage__c();
        lm.LogDate__c = logDate;
        lm.Message__c = message;
        lm.RequestId__c = 'setbeforecommit';
        lm.ParentJobId__c = 'setbeforecommit';
        lm.Source__c = source;
        logMessages.add(lm);
    }
}
