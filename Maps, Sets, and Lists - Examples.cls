public anonymous {
    Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id,
                                                               Name,
                                                               FirstName,
                                                               Account.Name,
                                                               LastModifiedBy.Name,
                                                               LastModifiedBy.Alias,
                                                               CreatedBy.Name,
                                                               CreatedBy.Alias,
                                                               Owner.Name,
                                                               Owner.Alias
                                                          FROM Contact
                                                         WHERE (Account.Name != null AND Account.Name != '')
                                                      ORDER BY Account.Name, Contact.Name ASC
                                                         LIMIT 100]);

    List<Id> contactIdList= new List<Id>(contactMap.keySet());
    contactIdList.sort();
    String s = '';
    for (Id contactId : contactIdList) {
        s += contactId + '\t' + contactMap.get(contactId).Name + '\n';
    }
    System.debug(s);

    List<Contact> contactList = new List<Contact>(contactMap.values());
    contactList.sort();
    s = '';
    for (Contact c : contactList) {
        s += c.Name + ' (' + c.Account.Name + ')\n';
    }
    System.debug(s);

    s = '';
    Integer n = 0 ;
    for(Id contactId : contactMap.keySet()) {
        s += ('0000000'+ (++n)).right(7) + ': ';  // lPad(7)
        s += contactId + '\t';
        s += contactMap.get(contactId).Name + '\t';
        s += contactMap.get(contactId).Account.Name + '\t';
        s += contactMap.get(contactId).Owner.Name + '\t';
        s += contactMap.get(contactId).CreatedBy.Name + '\t';
        s += contactMap.get(contactId).LastModifiedBy.Name + '\n';
    }
    System.debug(s);
}