/*----------------------------------------------------------------------------*/
/* @class         - SOSLExample.cls                                           */
/* @date          - 16-JUN-2024                                               */
/* @author        - David B. Mitchell                                         */
/* @description   - Sample SOSL query and results.                            */
/*----------------------------------------------------------------------------*/
String searchExpression = 'Burl* OR Express OR Frehley';
System.debug(Logginglevel.INFO, 'searchExpression: ' + searchExpression);

List<List<sObject>> results = [FIND :searchExpression
                                 IN NAME FIELDS
                          RETURNING Account(Name, BillingCity, BillingCountry),
                                    Contact(FirstName, LastName, Phone, Email, AccountId),
                                    Opportunity(Name, StageName, Probability, ExpectedRevenue)
];

List<Account>     accounts      = (List<Account>    )results[0];
List<Contact>     contacts      = (List<Contact>    )results[1];
List<Opportunity> opportunities = (List<Opportunity>)results[2];

for (Account a : accounts         ) { System.debug(LoggingLevel.INFO, a); }
for (Contact c : contacts         ) { System.debug(LoggingLevel.INFO, c); }
for (Opportunity o : opportunities) { System.debug(LoggingLevel.INFO, o); }
