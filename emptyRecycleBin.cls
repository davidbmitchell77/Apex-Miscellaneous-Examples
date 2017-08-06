public class BofA_SC_EmptyRecycleBin {
    // Logged in user must have "Modify All Data" permission
    // Max records to purge at a time = 200 (purgeBatchSize)
    // Records purged can be queried for approx. 24 using "QUERY ALL"

    public List<String> objNamesList = new List<String>();
    public List<ID> ids = new List<ID>();
    public static final Integer purgeBatchSize = 200;
    public static final Integer soqlLimit = 10000;

    public BofA_SC_EmptyRecycleBin () {
        objNamesList.add('Contact');
        objNamesList.add('Account');
        objNamesList.add('Opportunity');
        objNamesList.add('Lead');
    }

    public void run() {
        for (String objName : objNamesList) {
            runPurge(objName);
        }
    }

    public void runPurge(String objName) {
        ids.clear();
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