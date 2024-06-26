String objectApiName = 'Account';
String fieldNames = '';
String comma = '';
Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
for (String fieldName : fieldMap.keyset()) {
    System.debug(LoggingLevel.INFO, fieldName);
    fieldNames += comma + fieldName;
    comma = ', ';
}
System.debug(LoggingLevel.INFO, fieldNames);
