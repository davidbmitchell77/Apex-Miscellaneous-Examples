public class emptyRecycleBin_v2 {
    // Logged in user must have "Modify All Data" permission
    // Max records to purge at a time and SOQL Limit
    // are pulled in from custom settings.
    // Records purged can be queried for approx. 24 using "QUERY ALL"

    private final Map<String, Purge_Settings__c> purgeSettingsMap;
    private final Map<String, Purge_Object_Names__c> purgeObjectNamesMap;
    private final Integer purgeBatchSize;
    private final Integer soqlLimit;
    private final Integer logLevel;

    public emptyRecycleBin_v2() {
        purgeSettingsMap = Purge_Settings__c.getAll();
        purgeObjectNamesMap = Purge_Object_Names__c.getAll();
        purgeBatchSize = integer.valueOf(purgeSettingsMap.get('Purge Batch Size').Value__c);
        soqlLimit = integer.valueOf(purgeSettingsMap.get('SOQL Limit').Value__c);
        logLevel = integer.valueOf(purgeSettingsMap.get('Logging Level').Value__c);
    }

    public void run() {
        // Create sorted list of object names from purge object map
        List<String> sequenceList = new List<String>();
        sequenceList.addAll(purgeObjectNamesMap.keySet());
        sequenceList.sort();
        for (String sequence : sequenceList) {
            String objName = purgeObjectNamesMap.get(sequence).Object_Name__c;
            runPurge(objName);
        }
    }

    private void runPurge(String objName) {
        ID[] ids = new ID[purgeBatchSize];
        List<sObject> sObjects = Database.query(getQueryString(objName));
        System.debug('Purging ' + string.valueOf(sObjects.size()) + ' ' + objName + ' records from the recycle bin.');
        for (Integer i=0; i<sObjects.size(); i++) {
            ids[i] = sObjects[i].Id;
            if (ids.size() == purgeBatchSize || (i+1) == sObjects.size()) {
                emptyRecycleBin(ids);
                ids.clear();
            }
        }
    }

    private void emptyRecycleBin(ID[] ids) {
       try {
          Database.EmptyRecycleBinResult[] results = Database.emptyRecycleBin(ids);
          for (Database.EmptyRecycleBinResult result : results) {
             if (result.isSuccess()) {
                if (logLevel > 0) {
                   System.debug('Purged record ' + result.getId() + ' from recycle bin.');
                }
             } else {
                Database.Error[] errors = result.getErrors();
                for (Database.Error error : errors) {
                   System.debug('Error code: ' + error.getStatusCode());
                   System.debug('Error message: ' + error.getMessage());
                   System.debug('\n');
                }
             }
          }
       } catch (Exception e) {
          System.debug('Error: ' + e);
       }
    }

    public String getQueryString(String objName) {
        String result = '';
        result = 'SELECT Id FROM ';
        result += objName;
        result += ' WHERE isDeleted = true';
        result += ' ORDER BY SystemModStamp DESC';
        result += ' LIMIT ' + string.valueOf(soqlLimit);
        return(result);
    }
}
