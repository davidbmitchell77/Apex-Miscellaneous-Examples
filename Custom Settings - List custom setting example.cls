public anonymous {}
    // These two commands are equivalent for list custom setting:
    System.debug(USStatePostalCodes__c.getInstance('California').StateCode__c);
    System.debug(USStatePostalCodes__c.getValues('California').StateCode__c);

    // Create sorted list from list custom setting:
    Map<String, USStatePostalCodes__c> uspcMap = USStatePostalCodes__c.getAll();
    Set<String> uspcSet = uspcMap.keySet();
    List<String> uspcList = new List<String>();
    uspcList.addAll(uspcSet);
    uspcList.sort();

    String s = 'Name,State_Code__c\n';
    for (String name : uspcList) {
        s += name;
        s += ',' + uspcMap.get(name).StateCode__c + '\n';
    }
    System.debug(s);
}