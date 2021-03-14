global class initActivityCreatedDate implements Database.Batchable<sObject>
{
    global final String query;

    global initActivityCreatedDate()
    {
        query = 'SELECT Id, CreatedDate, CreatedDate__c FROM Task WHERE CreatedDate__c = null ORDER BY Id DESC LIMIT 100000';
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Task> tasks = new List<Task>();

        for (sObject s : scope)
        {
            Task t = (Task)s;
            t.CreatedDate__c = t.CreatedDate;
            tasks.add(t);
        }

        update tasks;
  }

    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob job = [SELECT Id,
                                   Status,
                                   NumberOfErrors,
                                   JobItemsProcessed,
                                   TotalJobItems,
                                   CreatedBy.Email
                              FROM AsyncApexJob
                             WHERE Id = :BC.getJobId()
                             LIMIT 1
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { job.CreatedBy.Email };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job initActivityCreatedDate__c ' + job.Status);
        mail.setPlainTextBody('The batch apex job ' + BC.getJobId() + ' processed ' + job.TotalJobItems + ' batches with ' + job.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
