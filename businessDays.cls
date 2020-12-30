public class businessDays
{
    /*----------------------------------------------------------------------------*/
    /* @class         - businessDays                                              */
    /* @date          - 29-DEC-2020                                               */
    /* @author        - David B. Mitchell                                         */
    /* @description   - Calulates date based on number of business days.          */
    /*----------------------------------------------------------------------------*/
    public Datetime add(Integer businessDays)
    {
        Datetime currentDate = System.now().date();
        Integer calendarDays = 0;
        Integer saturdays = 0;
        Integer sundays = 0;
        Integer holidays = 0;
        String mmddyyyy = 'MM-dd-yyyy';
        String weekday = 'EEEE';

        Map<Datetime,String> companyHolidays = new Map<Datetime,String>();
        molinaHolidays.put(Date.valueOf('2021-01-01'), 'New Year\'s Day');
        molinaHolidays.put(Date.valueOf('2021-01-18'), 'Martin Luther King Jr. Day');
        molinaHolidays.put(Date.valueOf('2021-02-15'), 'President\'s Day');
        molinaHolidays.put(Date.valueOf('2021-03-31'), 'Cesar Chavez Day');
        molinaHolidays.put(Date.valueOf('2021-05-31'), 'Memorial Day');
        molinaHolidays.put(Date.valueOf('2021-07-05'), 'Independence Day');
        molinaHolidays.put(Date.valueOf('2021-09-06'), 'Labor Day');
        molinaHolidays.put(Date.valueOf('2021-09-09'), 'California Admission Day');
        molinaHolidays.put(Date.valueOf('2021-09-24'), 'Native American Day');
        molinaHolidays.put(Date.valueOf('2021-11-11'), 'Veteran\'s Day');
        molinaHolidays.put(Date.valueOf('2021-11-25'), 'Thanksgiving');
        molinaHolidays.put(Date.valueOf('2021-12-24'), 'Christmas Day');

        for (Integer i=0; i<businessDays; i++)
        {
            Datetime dt = currentDate.addDays(i);
            if (dt.format(weekday) == 'Saturday') { saturdays++; }
            if (dt.format(weekday) == 'Sunday'  ) { sundays++;   }
            if (companyHolidays.containsKey(dt) ) { holidays++; }
            if (companyHolidays.containsKey(dt) )
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

        Datetime result = currentDate.addDays(calendarDays);

        System.debug('Business days (Mon - Fri): ' + businessDays);
        System.debug('Saturdays: ' + saturdays);
        System.debug('Sundays: ' + sundays);
        System.debug('Holidays: ' + holidays);
        System.debug('Total calendar days: ' + calendarDays);
        System.debug((currentDate.date() + ' + ' + calendarDays + ' calendar days = ' + result).replace(' 00:00:00', ''));

        return result;
    }
}
