public anonymous {

  Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id,
                                                              Name,
                                                              NumberOfEmployees,
                                                             (SELECT Contact.Id, Contact.Name FROM Contacts)
                                                         FROM Account
                                                     ORDER BY Name
                                                        LIMIT 100]);

  Set<Id> accountIds = accountsMap.keySet();
  System.debug('Records found: ' + accountIds.size());
  String border = '======================================';

  for (Id accountId : accountIds) {
      Account a = accountsMap.get(accountId);
      System.debug(a.Name + ' ' + ((a.NumberOfEmployees==null) ? 0 : a.NumberOfEmployees));
      for (Contact childContact : a.Contacts) {
        System.debug('\t' + childContact.Name);
      }
      System.debug(border);
  }
}
