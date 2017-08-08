public class emptyRecycleBin {
    // Logged in user must have "Modify All Data" permission
    // Max records to purge at a time = 200 (purgeBatchSize)
    // Records purged can be queried for approx. 24 using "QUERY ALL"

    public static final Integer purgeBatchSize = 200;
    public static final Integer soqlLimit = 10000;

    public emptyRecycleBin() {
        // Create sorted list from list custom setting:
        Map<String, Purge_Object_Names__c> purgeObjectMap = Purge_Object_Names__c.getAll();
        List<String> sequenceList = new List<String>();
        sequenceList.addAll(purgeObjectMap.keySet());
        sequenceList.sort();
        for (String sequence : sequenceList) {
            String objName = purgeObjectMap.get(sequence).Object_Name__c;
            runPurge(objName);
        }
    }

    public void runPurge(String objName) {
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

    public void emptyRecycleBin(ID[] ids) {
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