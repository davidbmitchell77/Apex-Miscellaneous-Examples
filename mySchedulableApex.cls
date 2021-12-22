global class mySchedulableApex implements Schedulable, Database.Batchable<sObject>
{
    /*----------------------------------------------------------------------------*/
    /* @class         - mySchedulableApex                                         */
    /* @date          - 17-DEC-2021                                               */
    /* @author        - David B. Mitchell (Infosys Limited)                       */
    /* @description   - Template for schedulable / batch apex class.              */
    /*----------------------------------------------------------------------------*/
    global final Boolean all;
    global final Boolean allOrNone;
    global final String query;
    global final Id campaignId;
    global final Integer batchSize;
    global final Integer cacheSize;
    global final Integer querySize;

    global mySchedulableApex()
    {
        all = false;
        allOrNone = true;
        batchSize = (25 * 1000);
        cacheSize = 4096;
        campaignId = [SELECT Id FROM Campaign WHERE IsActive = true LIMIT 1].Id;
        querySize = (25 * 1000);
        query = 'SELECT Id, '                           +
                       'Name, '                         +
                       'Title, '                        +
                       'Company, '                      +
                       'Street, '                       +
                       'City, '                         +
                       'State, '                        +
                       'PostalCode, '                   +
                       'Country, '                      +
                       'Phone, '                        +
                       'Email, '                        +
                       'Description '                   +
                  'FROM Lead '                          +
                 'WHERE CreatedDate = LAST_N_DAYS:30 '  +
                 'ORDER BY Id ASC '                     +
                 'LIMIT ' + querySize                   ;
    }

    global void execute(SchedulableContext SC)
    {
        Database.executeBatch(new mySchedulableApex(), batchSize);
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<CampaignMember> campaignMembers = new List<CampaignMember>();

        for (sObject o : scope)
        {
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaignId;
            cm.LeadId = ((Lead)o).Id;
            campaignMembers.add(cm);
        }

        List<Database.SaveResult> saveResults = Database.insert(campaignMembers, all);

        Integer i = 0;
        for (Database.SaveResult sr : saveResults)
        {
            String s = ((sr.isSuccess()) ? sr.getId() : sr.getErrors().get(0).getMessage());
            scope[i].put('Description', s);
            i++;
        }

        Database.update(scope, all);
    }

    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob job = [SELECT Id,
                                   ApexClass.Name,
                                   Status,
                                   JobItemsProcessed,
                                   TotalJobItems,
                                   NumberOfErrors
                              FROM AsyncApexJob
                             WHERE Id = :BC.getJobId()
                             LIMIT 1
        ];

        String priority = ((job.Status == 'Completed') ? 'Low' : 'High');
        String subject = 'Apex Job ' + job.Id + ': ' + job.Status;
        String txtBody = System.JSON.serializePretty(job);
        String optOutPolicy = 'FILTER';
        String toAddress = UserInfo.getUserEmail();

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ toAddress });
        email.setEmailPriority(priority);
        email.setOptOutPolicy(optOutPolicy);
        email.setSubject(subject);
        email.setPlainTextBody(txtbody);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    }
}
