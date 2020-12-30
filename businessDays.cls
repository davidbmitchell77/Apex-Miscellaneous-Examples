public class businessDays
{
    /*----------------------------------------------------------------------------*/
    /* @class         - businessDays                                              */
    /* @date          - 29-DEC-2020                                               */
    /* @author        - David B. Mitchell                                         */
    /* @description   - Calulates date based on number of business days.          */
    /*----------------------------------------------------------------------------*/
    public Date add(Integer businessDays)
    {
        Date currentDate = Date.today();
        Integer calendarDays = 0;
        Integer saturdays = 0;
        Integer sundays = 0;
        Integer holidays = 0;
        String mmddyyyy = 'MM-dd-yyyy';
        String weekday = 'EEEE';

        Map<String,String> companyHolidays = new Map<String,String>();
        companyHolidays.put('01-01-2021', 'New Year\'s Day');
        companyHolidays.put('01-18-2021', 'Martin Luther King Jr. Day');
        companyHolidays.put('02-15-2021', 'President\'s Day');
        companyHolidays.put('03-31-2021', 'Cesar Chavez Day');
        companyHolidays.put('05-31-2021', 'Memorial Day');
        companyHolidays.put('07-05-2021', 'Independence Day');
        companyHolidays.put('09-06-2021', 'Labor Day');
        companyHolidays.put('09-09-2021', 'California Admission Day');
        companyHolidays.put('09-24-2021', 'Native American Day');
        companyHolidays.put('11-11-2021', 'Veteran\'s Day');
        companyHolidays.put('11-25-2021', 'Thanksgiving');
        companyHolidays.put('12-24-2021', 'Christmas Day');

        for (Integer i=0; i<businessDays; i++)
        {
            Datetime dt = currentDate.addDays(i+1); // you lose 1 day wen you cast a date as datetime
            if (dt.format(weekday) == 'Saturday') { saturdays++; }
            if (dt.format(weekday) == 'Sunday'  ) { sundays++;   }
            if (companyHolidays.containsKey(dt.format(mmddyyyy))) { holidays++; }
            if (companyHolidays.containsKey(dt.format(mmddyyyy)))
            {
                String s = '';
                s += dt.format(mmddyyyy) + ': ';
                s += companyHolidays.get(dt.format(mmddyyyy)) + ' (';
                s += dt.format(weekday) + ')';
                System.debug(s);
            }
        }

        calendarDays += businessDays;
        calendarDays += saturdays;
        calendarDays += sundays;
        calendarDays += holidays;

        Date result = currentDate.addDays(calendarDays);

        System.debug('Business days (Mon - Fri): ' + businessDays);
        System.debug('Saturdays: ' + saturdays);
        System.debug('Sundays: ' + sundays);
        System.debug('Holidays: ' + holidays);
        System.debug('Total calendar days: ' + calendarDays);
        System.debug((currentDate + ' + ' + calendarDays + ' calendar days = ' + result).replace(' 00:00:00', ''));

        return result;
    }
}