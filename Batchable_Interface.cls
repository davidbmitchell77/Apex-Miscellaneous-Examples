global class initActivityCreatedDate__c implements Database.Batchable<sObject> {

  global final String query;

  global initActivityCreatedDate__c()
  {
    query = 'select Id, CreatedDate, CreatedDate__c from Activity order by Id DESC where CreatedDate__c = null limit 100000';
  }

  global Database.QueryLocator start(Database.BatchableContext BC)
  {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<sObject> scope)
  {
    for (sObject s : scope) {
      s.CreatedDate__c = s.CreatedDate;
    }

    update scope;
  }

  global void finish(Database.BatchableContext BC)
  {
    AsyncApexJob job = [SELECT Id,
                               Status,
                               NumberOfErrors,
                               JobItemsProcessed,
                               TotalJobItems,
                               CreatedBy.Email
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()
                       ];

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {a.CreatedBy.Email};
    mail.setToAddresses(toAddresses);
    mail.setSubject('Apex Batch Job initActivityCreatedDate__c ' + a.Status);
    mail.setPlainTextBody('The batch apex job ' + BC.getJobId() + ' processed ' + job.TotalJobItems + ' batches with ' + job.NumberOfErrors + ' failures.');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}