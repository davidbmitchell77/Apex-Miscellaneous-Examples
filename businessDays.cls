public class businessDays
{
    /*----------------------------------------------------------------------------*/
    /* @class         - businessDays                                              */
    /* @date          - 29-DEC-2020                                               */
    /* @author        - David B. Mitchell                                         */
    /* @description   - Calculates date based on number of business days added.   */
    /*----------------------------------------------------------------------------*/
    public Datetime add(Integer businessDays)
    {
        Integer calendarDays = 0;
        Integer saturdays = 0;
        Integer sundays = 0;
        Integer holidays = 0;
        String gmt = 'yyyy-MM-dd HH:mm:ssZ';
        String mmddyyyy = 'MM-dd-yyyy';
        String weekday = 'EEEE';

        Map<Datetime,String> californiaHolidays = new Map<Datetime,String>();
        californiaHolidays.put(Date.valueOf('2021-01-01'), 'New Year\'s Day');
        californiaHolidays.put(Date.valueOf('2021-01-18'), 'Martin Luther King Jr. Day');
        californiaHolidays.put(Date.valueOf('2021-02-15'), 'President\'s Day');
        californiaHolidays.put(Date.valueOf('2021-03-31'), 'Cesar Chavez Day');
        californiaHolidays.put(Date.valueOf('2021-05-31'), 'Memorial Day');
        californiaHolidays.put(Date.valueOf('2021-07-05'), 'Independence Day');
        californiaHolidays.put(Date.valueOf('2021-09-06'), 'Labor Day');
        californiaHolidays.put(Date.valueOf('2021-09-09'), 'California Admission Day');
        californiaHolidays.put(Date.valueOf('2021-09-24'), 'Native American Day');
        californiaHolidays.put(Date.valueOf('2021-11-11'), 'Veteran\'s Day');
        californiaHolidays.put(Date.valueOf('2021-11-25'), 'Thanksgiving');
        californiaHolidays.put(Date.valueOf('2021-12-24'), 'Christmas Day');

        Datetime currentDate = Datetime.valueOf(System.now().format(gmt).substring(0,10) + ' 00:00:00.000Z').date();
        System.debug('currentDate.format(gmt): ' + currentDate.format(gmt));
        for (Integer i=0; i<businessDays; i++)
        {
            Datetime dt = currentDate.addDays(i);
            if (dt.format(weekday) == 'Saturday'  ) { saturdays++; }
            if (dt.format(weekday) == 'Sunday'    ) { sundays++;   }
            if (californiaHolidays.containsKey(dt)) { holidays++;  }
            if (californiaHolidays.containsKey(dt))
            {
                String s = '';
                s += dt.format(mmddyyyy) + ': ';
                s += californiaHolidays.get(dt) + ' (';
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
