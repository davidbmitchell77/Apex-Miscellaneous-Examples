/*
Questions
1.  How do we determine Visible on Layout?  Do we need entries for both green--develop and vector--sit?
2.  What do we do about fields that exist in green--develop that are not in vector--sit?
3.  What is the ACL section and how do we fill that out?
4.  Do we add fields that are not in the spreadsheet?
5.  Check w/Howard Site__c vs Legal_Entity__c
6. How do we determine field purpose / field obsolete
*/


//SOQL Query to retrieve field metadata:
SELECT EntityDefinition.Label,
       FieldDefinition.QualifiedApiName,
       FieldDefinition.Label,
       FieldDefinition.DataType,
       FieldDefinition.Description,
       InlineHelptext,
       DefaultValueFormula
FROM   EntityParticle
WHERE  EntityDefinition.Label = 'Opportunity Product'


//SOQL that allows you to copy and paste description:
SELECT EntityDefinition.Label,
       QualifiedApiName,
       Label,
       Description
FROM   FieldDefinition
WHERE  EntityDefinition.Label = 'Opportunity Product'


       ! IMPORTANT!
       These queries will not return fields you do not have at least read access to.



//Anonymous apex code for extracting field descriptions, picklist values, and help text:
String lastApiName = '';
String objectName = 'Product2';
Set<String> fieldNames = new Set<String>();
System.debug(LoggingLevel.INFO, ',Object Name,Field Name,Field Label,Type,Standard vs Custom,Picklist Values,Controlling Field,Default Value,Description,Help Text,Required');
for (Integer i=0; i<10; i++) {
    for (EntityParticle ep : [SELECT EntityDefinition.Label,
                                     QualifiedApiName,
                                     Label,
                                     DataType,
                                     FieldDefinition.Description,
                                     FieldDefinition.ControllingFieldDefinition.Label,
                                     FieldDefinition.DataType,
                                     InlineHelpText,
                                     DefaultValueFormula,
                                     EntityDefinition.QualifiedApiName,
                                     FieldDefinition.IsNillable
                                FROM EntityParticle
                               WHERE EntityDefinition.QualifiedApiName = :objectName AND QualifiedApiName > :lastApiName
                            ORDER BY QualifiedApiName ASC
                               LIMIT 200
    ]) {
        lastApiName = ep.QualifiedApiName;
        String fieldName = ep.QualifiedApiName;
        String fieldLabel = ep.Label;
        String dataType = ep.FieldDefinition.DataType;
        String standardVsCustom = ((fieldName.indexOf('__c') > 0) ? 'Custom' : 'Standard');
        String description = ((ep.FieldDefinition.Description != null) ? ep.FieldDefinition.Description : '');
        String helptext = ((ep.InlineHelpText != null) ? ep.InlineHelpText : '');
        String controllingField = ((ep.FieldDefinition.ControllingFieldDefinition.Label != null) ? ep.FieldDefinition.ControllingFieldDefinition.Label : '');
        String defaultValue = ((ep.DefaultValueFormula != null) ? ep.DefaultValueFormula : '');
        String isRequired = (ep.FieldDefinition.IsNillable ? '' : 'Yes');
        String picklist = '';
        String comma = '';
        if (dataType.indexOf('Picklist') >= 0) {
            List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{ ep.EntityDefinition.QualifiedApiName });
            for (Schema.DescribeSobjectResult res : results) {
                for (Schema.PicklistEntry entry : res.fields.getMap().get(ep.QualifiedApiName).getDescribe().getPicklistValues()) {
                    if (entry.isActive()) {
                        String label = entry.getLabel().replaceAll(',', '').replaceAll('"', '\'');
                        String value = entry.getValue().replaceAll(',', '').replaceAll('"', '\'');
                        String isDefaultValue = (entry.isDefaultValue() ? 'Yes' : '');
                        picklist += comma + value.replaceAll('"', '\'').replaceAll(',', ' ');
                        comma = ', ';
                    }
                }
            }
        }
        String s = ',' + objectName;
        s += ',' + fieldName;
        s += ',' + fieldLabel.replaceAll(',', ' ');
        s += ',' + dataType.replaceAll(',', ' ');
        s += ',' + standardVsCustom;
        s += ',' + ((picklist > '') ? ('"' + picklist + '"') : picklist);
        s += ',' + controllingField.replaceAll('\n', '  ').replaceAll('"', '\'').replaceAll(',', ' ');
        s += ',' + defaultValue.replaceAll('\n', '  ').replaceAll('"', '\'').replaceAll(',', ' ');
        s += ',' + description.replaceAll('\n', '  ').replaceAll('"', '\'').replaceAll(',', ' ');
        s += ',' + helpText.replaceAll('\n', '  ').replaceAll('"', '\'').replaceAll(',', ' ');
        s += ',' + isRequired;
        if (!fieldNames.contains(fieldName)) {
            System.debug(LoggingLevel.INFO, s);
            fieldNames.add(fieldName);
        }
    }
}


//Anonymous apex code for extracting field counts:
String objectName = 'Opportunity_Solution_And_Workload__c';
Set<String> fieldNames = new Set<String>();
System.debug(LoggingLevel.INFO, ',Object Name,Field Name,Type,COUNT()');
for (FieldDefinition fd : [SELECT Id, QualifiedApiName, DataType
                                 FROM FieldDefinition
                                WHERE EntityDefinition.QualifiedApiName = :objectName
                             ORDER BY QualifiedApiName
                                LIMIT 49
    
]) {
    if (!fieldNames.contains(fd.QualifiedApiName)) {
        try {
            List<sObject> l = Database.query('SELECT COUNT(' + fd.QualifiedApiName + ') ' + fd.QualifiedApiName + ' FROM ' + objectName);
            System.debug(LoggingLevel.INFO, ',' + objectName + ',' + fd.QualifiedApiName + ',' + fd.DataType.replaceAll(',', ' ') + ',' + l[0].get(fd.QualifiedApiName));
        }
        catch(Exception e) {
            System.debug(LoggingLevel.INFO, ',' + objectName + ',' + fd.QualifiedApiName + ',' + fd.DataType.replaceAll(',', ' ') + ',' + e.getMessage());
        }
        fieldNames.add(fd.QualifiedApiName);
    }
}

