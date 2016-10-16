 anonymous {
    String s = '';
    s += 'Manually create a map:\n';
    Map<String, String> myMap = new Map<String, String>{
      'Rabbit'=>'Hotot',
      'Dog'=>'Beagle'
    };
    myMap.put('Cat', 'Tabby');
    s += 'myMap: ' + myMap + '\n';
    s += 'myMap.keySet(): ' + myMap.keySet() + '\n';
    s += 'myMap.values(): ' + myMap.values() + '\n';
    s += 'myMap.get(\'Dog\'): ' + myMap.get('Dog');
    System.debug(s);

    s = 'Manually create and sort a list ...\n';
    List<String> myList = new List<String>{
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
        'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
        'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
        'y', 'z'
    };
    myList.sort();
    s += 'Print list in ascending order: ';
    for (Integer i=0; i<myList.size(); i++) {
        s += ((i==0) ? '' : ', ') + myList[i];
    }
    s += '\nThen in descending order: ';
    for (Integer i=myList.size(); i>0; i--) {
        s += ((i==myList.size()) ? '' : ', ') + myList[(i-1)];
    }
    System.debug(s);

    // More techniques with maps, sets, and lists:
    s = 'Use SOQL to create a set of account objects:\n';
    Set<Account> mySet2 = new Set<Account>([select Name from Account limit 100]);
    for (Account a : mySet2) {
        s += a + '\n';
    }
    System.debug(s);

    s = 'Use SOQL to create a map of account Ids and their associated records...\n';
    Map<Id, Account> accountMap = new Map<Id, Account>([
        SELECT Id,
                     Name,
                     Type,
                     NumberOfEmployees
          FROM Account
           LIMIT 100
      ]);

    s += 'Then use the account records to create a set ';
    s += 'of unique account types:\n';
    Set<String> accountTypes = new Set<String>();
    for (Account a : accountMap.values()) {
        if (a.Type != null && a.Type != '') {
           accountTypes.add(a.Type);
        }
    }
    for (String accountType : accountTypes) {
        s += accountType + '\n';
    }
    System.debug(s);

    s = 'Use the map.values() method to create a list of account records...\n';
    s += 'Then use list.sort() method to sort the records in the list by name:\n';
    List<Account> accountList = accountMap.values();
    accountList.sort();
    for (Account a : accountList) {
        s += a.name + '\n';
    }
    System.debug(s);

    s = 'Now reprint the list in descending order:\n';
    for (Integer i=accountList.size(); i>0; i--) {
        s += accountList[(i-1)].Name + '\n';
    }
    System.debug(s);
}
