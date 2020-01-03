public class guid
{
    public static String generate()
    {
        String.result = '';
        Blob b = Crypto.GenerateAESKey(128);
        String s = EncodingUtil.ConvertTohex(b);
        result = s.substring(0,8);
        result += '-' + s.substring(8,12);
        result += '-' + s.substring(12,16);
        result += '-' + s.substring(16, 20);
        result += '-' + s.substring(20);
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
        System.debug('guid.generate().toLowerCase(): ' + result.toLowerCase());
        System.debug('guid.generate().toUpperCase(): ' + result.toUpperCase());
        System.debug('guid.generate().replace(\'-\', \'\'): ' + result.replace('-', ''));
        System.assertEquals(32, result.replace('-', '').length());
    }
}
