public class Infosys_Utilities
{
    /*----------------------------------------------------------------------------*/
    /* @class         - Infosys_Utilities                                         */
    /* @date          - 07-MAR-2021                                               */
    /* @author        - David B. Mitchell (Infosys / Molina AMS Team)             */
    /* @description   - Miscellaneous apex class utility methods.                 */
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
            String outerClassName = 'Infosys_Utilities';
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
}