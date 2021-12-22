@isTest
private class myQueueableApex_Test
{
    /*----------------------------------------------------------------------------*/
    /* @class         - myQueueableApex_Test                                      */
    /* @date          - 120-DEC-2021                                              */
    /* @author        - David B. Mitchell (Infosys Limited)                       */
    /* @description   - Test class for queueable / finalizer apex class           */
    /*                  myQueueableApex.                                          */
    /*----------------------------------------------------------------------------*/
    private static TestMethod void testMethod_01()
    {
        Campaign c = new Campaign();
        c.Name = 'Test Campaign 1';
        c.StartDate = Date.newInstance(2021, 01, 01);
        c.EndDate = c.StartDate.addYears(1);
        c.IsActive = true;
        insert c;

        Lead l = new Lead();
        l.FirstName = UserInfo.getFirstName();
        l.LastName = UserInfo.getLastName();
        l.Title = 'VP - Technology';
        l.Company = 'Apex Software Solutions, Inc.';
        l.Email = UserInfo.getUserEmail();
        l.City = 'San Diego';
        l.Street = '755 Kuhn Ave';
        l.State = 'CA';
        l.PostalCode = '92123';
        l.Country = 'United States';
        l.Phone = '(555) 555-5555';
        insert l;

        Test.startTest();
        String jobId = System.enqueueJob(new myQueueableApex());
        Test.stopTest();

        System.assertEquals(18, jobId.length());
    }
}
