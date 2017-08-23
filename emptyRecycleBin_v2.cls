public class emptyRecycleBin {
    // Logged in user must have "Modify All Data" permission
    // Max records to purge at a time and SOQL Limit
    // are pulled in from custom settings.
    // Records purged can be queried for approx. 24 using "QUERY ALL"

    private static final Integer purgeBatchSize;
    private static final Integer soqlLimit;

    public emptyRecycleBin() {
        // Get Purge settings values
        Map<String, Purge_Settings__c> purgeSettingsMap = Purge_Settings__c.getAll();
        purgeBatchSize = purgeSettingsMap.get('Purge Batch Size').Value__c;
        soqlLimit = purgeSettingsMap.get('SOQL Limit').Value__c;
    }

    public void run() {
        // Create sorted list of object names from list custom setting
        Map<String, Purge_Object_Names__c> purgeObjectMap = Purge_Object_Names__c.getAll();
        List<String> sequenceList = new List<String>();
        sequenceList.addAll(purgeObjectMap.keySet());
        sequenceList.sort();
        for (String sequence : sequenceList) {
            String objName = purgeObjectMap.get(sequence).Object_Name__c;
            runPurge(objName);
        }
    }

    private void runPurge(String objName) {
        ID[] ids = new ID[purgeBatchSize];
        System.debug('Purging ' + objName + ' object records from recycle bin.');
        List<sObject> sObjects = Database.query(getQueryString(objName));
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
                System.debug('Recycled ID: ' + result.getId());
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
        result += ' LIMIT ' + soqlLimit;
        return(result);
    }
}