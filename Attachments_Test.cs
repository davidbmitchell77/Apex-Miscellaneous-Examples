@isTest
private class Attachments_Test
{
    /*-----------------------------------------------------------------------------*/
    /* @class         - Attachments_Test                                           */
    /* @date          - 25-AUG-2022                                                */
    /* @author        - David B. Mitchell                                          */
    /* @description   - Test class for apex class Attachments.                     */
    /*-----------------------------------------------------------------------------*/
    @isTest
    private static void test01()
    {
        String csvBody = 'columnA,columnB,columnC,columnD\n';
        csvBody += 'cellA1,cellB1,CellC1,CellD1\n';

        ContentVersion cv = new ContentVersion();
        cv.Title = 'ABC';
        cv.PathOnClient = 'test01';
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf(csvBody)));
        insert cv;

        Test.startTest();
        Attachments att = new Attachments();
        att.readCSVFile(cv.Id);
        Test.stopTest();

        Integer expected = 1;
        Integer actual = [SELECT Id FROM ContentVersion LIMIT 200].size();
        System.assertEquals(expected, actual, 'Expected ContentVersion record count mismatch.');
    }

    @isTest
    private static void test02()
    {
        Test.startTest();
        Attachments att = new Attachments();
        att.readCSVFile('foobar');
        Test.stopTest();

        Integer expected = 0;
        Integer actual = [SELECT Id FROM ContentVersion LIMIT 200].size();
        System.assertEquals(expected, actual, 'Expected ContentVersion record count mismatch.');
    }
}
