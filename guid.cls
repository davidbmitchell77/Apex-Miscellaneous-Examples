public class guid {
  public static String generate() {
    Blob b = Crypto.GenerateAESKey(128);
    String h = EncodingUtil.ConvertTohex(b);
    String result = h.substring(0,8) + '-' + h.substring(8,12) + '-' + h.substring(12,16) + '-' + h.substring(16, 20) + '-' + h.substring(20);
    return(result);
  }
}

@isTest
private class guid_test{
  static TestMethod void generate() {
    String result = '';
    result = guid.generate();
    System.debug('guid.generate(): ' + result);
    System.assertEquals(32, result.replace('-', '').length());
  }
}
