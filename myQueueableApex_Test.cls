@isTest
public class myQueueableApex_Test
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
        Test.startTest();
        String jobId = System.enqueueJob(new myQueueableApex());
        Test.stopTest();

        System.assertEquals(18, jobId.length());
    }
}
