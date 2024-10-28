public with sharing class AccountUltimateParents_Batch implements Database.Batchable<sObject>, Database.Stateful {

    public Map<Id,Id> accountParentIds;
    public Map<Id,Id> accountChildIds;
    public Boolean isFirstRun;

    private final Integer batchSize;

    public AccountUltimateParents_Batch() {
        this.batchSize = 200;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        if (accountParentIds == null) {
            isFirstRun = true;
            accountParentIds = new Map<Id,Id>();
            String query = 'SELECT Id, ParentId, UltimateParentId__c FROM Account WHERE ParentId = null';
            return Database.getQueryLocator(query);
        }
        else {
            String query = 'SELECT Id, ParentId, UltimateParentId__c FROM Account WHERE ParentId IN :parentIds';
            Map<String,Object> bindMap = new Map<String,Object>{ 'parentIds' => accountParentIds.keySet() };
            return Database.getQueryLocatorWithBinds(query, bindMap, AccessLevel.USER_MODE);
        }
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Account> updatedAccounts = new List<Account>();
        for (Account a : (List<Account>)scope) {
            if (isFirstRun) {
                accountParentIds.put(a.Id, a.Id);
            }
            else {
                Id ultimateParentId = accountParentIds.get(a.ParentId);
                accountChildIds.put(a.Id, ultimateParentId);
                updatedAccounts.add(new Account(Id=a.Id, UltimateParentId__c=ultimateParentId));
            }
        }
        if (!updatedAccounts.isEmpty()) {
            List<Database.SaveResult> saveResults = Database.update(updatedAccounts, false);
            for (Database.SaveResult sr : saveResults) {
                if (!sr.isSuccess()) {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, 'Apex class AccountUltimateParentsBatch.execute Database.update error:');
                        System.debug(LoggingLevel.ERROR, err.getMessage());
                        System.debug(LoggingLevel.ERROR, err.getFields());
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        if (isFirstRun || !accountChildIds.isEmpty()) {
            AccountUltimateParents_Batch batchJob = new AccountUltimateParents_Batch();
            batchJob.accountParentIds = ((isFirstRun) ? accountParentIds : accountChildIds);
            batchJob.accountChildIds = new Map<Id,Id>();
            batchJob.isFirstRun = false;
            Database.executeBatch(batchJob, batchSize);
        }
    }
}
