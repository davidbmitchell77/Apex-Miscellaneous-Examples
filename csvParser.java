/*-----------------------------------------------------------------------------*/
/* @class         - csvParser                                                  */
/* @date          - 26-AUG-2022                                                */
/* @author        - David B. Mitchell                                          */
/* @description   - Anonymous Apex class for parsing csv data.                 */
/*-----------------------------------------------------------------------------*/

String body = '';

String csv = 'Id,Name,Phone,Address,State,PostalCode';
csv += '\n';

csv += ''  + '0000000001';
csv += ',' + '"Blue Oasis Technologies, Inc."';
csv += ',' + '(619) 216-1001';
csv += ',' + '380 Fourth Street';
csv += ',' + 'CA';
csv += ',' + '90660';
csv += '\n';

csv += ''  + '0000000002';
csv += ',' + '"Alfred ""Eddy"" Neuman"';
csv += ',' + '(888) 562-5442';
csv += ',' + '88 Citrus Way';
csv += ',' + 'FL';
csv += ',' + '20110';
csv += '\n';

csv += ''  + '0000000003';
csv += ',' + 'Gene Simmons';
csv += ',' + '(213) 282-2882';
csv += ',' + '1 Rodeo Dr';
csv += ',' + 'CA';
csv += ',' + '90210';
csv += '\n';

csv += ''  + '0000000004';
csv += ',' + '"Paul ""Ace"" Frehley"';
csv += ',' + '(212) 222-5978';
csv += ',' + '88 Citrus Way';
csv += ',' + 'NY';
csv += ',' + '10468';
csv += '\n';

for (String row : csv.split('\n'))
{
    if (!row.replace('""', '&quot;').contains('"')) {
      body += row + '\n';
    }
    else
    {
        String s = row.replace('""', '&quot;');
        String[] values = s.split(',');
        for (Integer i=0; i<values.size(); i++)
        {
            if (values[i] > '')
            {
                String buffer = values[i];
                if (values[i].startsWith('"') && !values[i].contains('&quot;')) { buffer +=  '&comma;'; }
                if (!buffer.endsWith('&comma;')) { buffer += ','; }
                body += buffer;
            }
        }
        body = body.removeEnd(',') + '\n';
    }
}

body = body.replace('&quot;', '""');
body = body.removeEnd('\n');

System.debug(LoggingLevel.INFO, 'body:\n' + body);
