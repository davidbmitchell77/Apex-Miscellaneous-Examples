@isTest
public class initActivityCreatedDate_Test
{
    static testMethod void testMethod1()
    {
        Account a = new Account(Name = 'Test Account');
        insert a;

        List<Task> tasks = new List<Task>();
        for (Integer i=0; i<200; i++)
        {
            Task t = new Task();
            t.WhatId = a.Id;
            t.Subject = 'Task ' + i;
            t.Status = 'New';
            t.Priority = 'Normal';
            t.CallType = 'Outbound';
            t.ActivityDate = System.today();
            t.CreatedDate__c = null;
            tasks.add(t);
        }
        insert tasks;

        Test.startTest();
        initActivityCreatedDate obj = new initActivityCreatedDate();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}
