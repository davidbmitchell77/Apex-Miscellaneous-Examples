public class dbm77__Utilities
{
    /*----------------------------------------------------------------------------*/
    /* @class         - dbm77__Utilities                                          */
    /* @date          - 07-MAR-2021                                               */
    /* @author        - David B. Mitchell                                         */
    /* @description   - Apex Utility Methods class.                               */
    /*----------------------------------------------------------------------------*/
    public class RecordTypes
    {
        public String getIdByName(String objectName, String recordTypeName)
        {
            String result = null;

            try
            {
                Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
                Schema.DescribeSObjectResult objectDescription = objectType.getDescribe();
                Schema.RecordTypeInfo rti = objectDescription.getRecordTypeInfosByName().get(recordTypeName);
                result = rti.getRecordTypeId();
            }
            catch(Exception e)
            {
                logException('getIdByName', e);
            }

            return result;
        }

        public String getIdByDeveloperName(String objectName, String recordTypeDeveloperName)
        {
            String result = null;

            try
            {
                Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
                Schema.DescribeSObjectResult objectDescription = objectType.getDescribe();
                Schema.RecordTypeInfo rti = objectDescription.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName);
                result = rti.getRecordTypeId();
            }
            catch(Exception e)
            {
                logException('getIdByDeveloperName', e);
            }

            return result;
        }

        private void logException(String methodName, Exception e)
        {
            String outerClassName = 'dbm77__Utilities';
            String innerClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
            Integer lineNumber = e.getLineNumber();
            String message = e.getMessage();
            String typeName = e.getTypeName();
            String stackTrace = e.getStackTraceString();

            String s = '';
            s += 'Apex Class: ' + outerClassName + '.' + innerClassName + '\n';
            s += 'Method: ' + methodName + '\n';
            s += 'Line Number: ' + lineNumber + '\n';
            s += 'Type of Exception: ' + typeName + '\n';
            s += 'Message: ' + message + '\n';
            s += 'Stack Trace: ' + stackTrace; 
            System.debug(s);
        }
    }

    public class guid
    {
        public String generate()
        {
            String result = '';
            Blob b = Crypto.generateAESKey(128);
            String s = EncodingUtil.convertToHex(b);
            result = s.substring(0,8);
            result += '-' + s.substring(8,12);
            result += '-' + s.substring(12,16);
            result += '-' + s.substring(16,20);
            result += '-' + s.substring(20);
            result = result.toUpperCase();
            return result;
        }

        public String generateWithoutDashes()
        {
            String result = '';
            result = generate();
            return result;
        }

        public Boolean isValid(String guid)
        {
            Boolean result = false;
            if (!String.isEmpty(guid)) {
                if (guid.length() == 36) {
                    if (guid.split('-').size() == 5) {
                        if (guid.split('-')[0].length() == 8) {
                            if (guid.split('-')[1].length() == 4) {
                                if (guid.split('-')[2].length() == 4) {
                                    if (guid.split('-')[3].length() == 4) {
                                        if (guid.split('-')[4].length() == 12) {
                                            result = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return result;
        }
    }

    public class uuid
    {
        public String generate()
        {
            String result = '';
            Blob b = Crypto.generateAESKey(128);
            String s = EncodingUtil.convertToHex(b);
            result = s.substring(0,8);
            result += '-' + s.substring(8,12);
            result += '-' + s.substring(12,16);
            result += '-' + s.substring(16,20);
            result += '-' + s.substring(20);
            result = result.tolowerCase();
            return result;
        }

        public String generateWithoutDashes()
        {
            String result = '';
            result = generate();
            return result;
        }

        public Boolean isValid(String uuid)
        {
            Boolean result = false;
            if (!String.isEmpty(uuid)) {
                if (uuid.length() == 36) {
                    if (uuid.split('-').size() == 5) {
                        if (uuid.split('-')[0].length() == 8) {
                            if (uuid.split('-')[1].length() == 4) {
                                if (uuid.split('-')[2].length() == 4) {
                                    if (uuid.split('-')[3].length() == 4) {
                                        if (uuid.split('-')[4].length() == 12) {
                                            result = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return result;
        }
    }
}
