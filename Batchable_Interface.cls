global class initActivityCreatedDate implements Database.Batchable<sObject>
{
    global final String query;

    global initActivityCreatedDate()
    {
        query = 'SELECT Id, CreatedDate, CreatedDate__c FROM Task WHERE CreatedDate__c = null ORDER BY Id DESC LIMIT 100000';
    }

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        for (sObject obj : scope)
        {
            Datetime value = obj.get('CreatedDate');
            obj.put('CreatedDate__c', value);
        }

        if (scope.size() > 0) {
           Database.update(scope, false);
        }
    }

    global void finish(Database.BatchableContext bc)
    {
        AsyncApexJob job = [SELECT Id,
                                   Status,
                                   NumberOfErrors,
                                   JobItemsProcessed,
                                   TotalJobItems,
                                   CreatedBy.Email
                              FROM AsyncApexJob
                             WHERE Id = :bc.getJobId()
                             LIMIT 1
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String> { job.CreatedBy.Email };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job initActivityCreatedDate__c ' + job.Status);
        mail.setPlainTextBody('The batch apex job ' + BC.getJobId() + ' processed ' + job.TotalJobItems + ' batches with ' + job.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });
    }
}
