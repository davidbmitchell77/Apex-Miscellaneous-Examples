String sobjname = 'Account';
//String sobjname = 'Contact';
//String sobjname = 'Lead';
//String sobjname = 'Opportunity';
String s = '';
String queryStr = 'select id, name from ' + sobjname + ' limit 100';
List<sObject> sObjectList = Database.query(queryStr);
sObjectList.sort();
if (sObjectList.getSObjectType() == Account.sObjectType) {
    List<Account> accountList = (List<Account>)sObjectList;
    for (Account a : accountList) {
            s += a.Name + '\n';
    }
}
else if (sObjectList.getSObjectType() == Contact.sObjectType) {
    List<Contact> contactList = (List<Contact>)sObjectList;
    for (Contact c : contactList) {
            s += c.Name +  '\n';
    }
}
else if (sObjectList.getSObjectType() == Lead.sObjectType) {
    List<Lead> leadList = (List<Lead>)sObjectList;
    for (Lead l : leadList) {
            s += l.Name + '\n';
    }
}
else {
    for (sObject sObj : sObjectList) {
            s += sObj.get('Name') + '\n';
    }
}
System.debug(s);
