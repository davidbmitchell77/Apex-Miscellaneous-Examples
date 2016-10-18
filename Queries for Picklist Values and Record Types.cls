List<Schema.PicklistEntry> picklist = new List<Schema.PicklistEntry>();
picklist = Account.Type.getDescribe().getPicklistValues();

Map<String, String> myMap = new Map<String, String>();
for (Schema.PicklistEntry p : picklist) {
   myMap.put(p.Label, p.Value);
}
Set<String> myKeySet = myMap.keySet();
List<String> myList = new List<String>();
myList.addAll(myKeySet);
myList.sort();

String s = '';
for (String l : myList) {
  s += l + ', ' + myMap.get(l) + '\n';
}
System.debug(s);

List<Schema.RecordTypeInfo> recordTypes = Lead.SObjectType.getDescribe().getRecordTypeInfos();
for (Schema.RecordTypeInfo rt : recordTypes) {
    System.debug(rt.getName());
    System.debug(rt.isAvailable());
    System.debug(rt.isMaster());
}

List<RecordType> recordTypes2 = [SELECT Id, SobjectType, Name FROM RecordType LIMIT 100];
System.debug(recordTypes2.size());
for (RecordType rt2 : recordTypes2) {
    System.debug(rt2.Id + ',' + rt2.SobjectType + ',' + rt2.Name);
}
