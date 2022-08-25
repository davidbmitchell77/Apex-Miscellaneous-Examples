public with sharing class Attachments
{
    /*-----------------------------------------------------------------------------*/
    /* @class         - Attachments                                                */
    /* @date          - 25-AUG-2022                                                */
    /* @author        - David B. Mitchell                                          */
    /* @description   - Apex class for reading Salesforce record file attachments. */
    /*-----------------------------------------------------------------------------*/
    private Map<String,String> delims = new Map<String,String>();

    public Attachments()
    {
        this.delims.put('csv',  ',');
        this.delims.put('tab', '\t');
        this.delims.put('tsv', '\t');
        this.delims.put('txt', '\t');
    }

    public void readCSVFile(String versionId)
    {
        List<ContentVersion> cv = [SELECT Id,
                                          FileExtension,
                                          VersionData,
                                          IsLatest,
                                          IsDeleted
                                     FROM ContentVersion
                                    WHERE Id = :versionId
                                      AND IsDeleted = false
                                    LIMIT 1
        ];

        if (!cv.isEmpty())
        {
            String delim = delims.get(cv[0].FileExtension);
            delim = ((delim == null) ? ',' : delim);

            String[] rows = decode(cv[0].VersionData).split('\n');
            String[] cols = rows[0].split(delim);

            Map<String,String> data = new Map<String,String>();

            for (String row : rows)
            {
                String[] values = row.split(delim);

                data.clear();

                for (Integer j=0; j<(cols.size() - 1); j++) {
                    data.put(cols[j], ((j <= (values.size() - 1)) ? clean(values[j]) : null));
                }

                System.debug(LoggingLevel.INFO, 'data: ' + System.JSON.serialize(data));
            }
        }
        else {
            System.debug(LoggingLevel.WARN, 'ContentVersion record with id: "' + versionId + '" not found or has been deleted.');
        }
    }

    private String clean(String s)
    {
        String result = s;
        result = result.replace('&#44', ',');
        return result;
    }

    private String decode(Blob b)
    {
        String result = null;
        result = EncodingUtil.base64Decode(EncodingUtil.base64Encode(b)).toString();
        return result;
    }
}
