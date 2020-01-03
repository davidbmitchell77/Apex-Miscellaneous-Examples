public class guid
{
    public static String generate()
    {
        String.result = '';
        Blob b = Crypto.GenerateAESKey(128);
        String s = EncodingUtil.ConvertTohex(b);
        result = s.substring(0,8) + '-' + s.substring(8,12) + '-' + s.substring(12,16) + '-' + s.substring(16, 20) + '-' + s.substring(20);
        result = result.toUpperCase();
        return result;
    }
}

@isTest
private class guid_test
{
    private static void generate()
    {
        String result = '';
        result = guid.generate();
        System.debug('guid.generate(): ' + result);
        System.assertEquals(32, result.replace('-', '').length());
    }
}
