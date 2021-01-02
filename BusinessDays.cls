public class BusinessDays
{
    /*----------------------------------------------------------------------------*/
    /* @class         - BusinessDays                                              */
    /* @date          - 29-DEC-2020                                               */
    /* @author        - David B. Mitchell                                         */
    /* @description   - Calculates date based on number of business days added.   */
    /*----------------------------------------------------------------------------*/
    public static Datetime add(Integer businessDays)
    {
        Date currentDate = Date.today();
        Integer calendarDays = 0;
        Integer saturdays = 0;
        Integer sundays = 0;
        Integer holidays = 0;
        String mmddyyyy = 'MM-dd-yyyy';
        String weekday = 'EEEE';
        String yyyymmdd = 'yyyy-MM-dd';

        Map<String,String> californiaHolidays = new Map<String,String>();
        californiaHolidays.put('2021-01-01', 'New Year\'s Day');
        californiaHolidays.put('2021-01-18', 'Martin Luther King Jr. Day');
        californiaHolidays.put('2021-02-15', 'President\'s Day');
        californiaHolidays.put('2021-03-31', 'Cesar Chavez Day');
        californiaHolidays.put('2021-05-05', 'Cinco de Mayo');
        californiaHolidays.put('2021-05-31', 'Memorial Day');
        californiaHolidays.put('2021-07-05', 'Independence Day');
        californiaHolidays.put('2021-09-06', 'Labor Day');
        californiaHolidays.put('2021-09-09', 'California Admission Day');
        californiaHolidays.put('2021-09-24', 'Native American Day');
        californiaHolidays.put('2021-10-11', 'Columbus Day');
        californiaHolidays.put('2021-11-11', 'Veteran\'s Day');
        californiaHolidays.put('2021-11-25', 'Thanksgiving');
        californiaHolidays.put('2021-12-24', 'Christmas Day');

        for (Integer i=0; i<businessDays; i++)
        {
            Datetime dt = Datetime.valueOf(String.valueOf(currentDate.addDays(i)) + ' 00:00:00Z');
            if (dt.format(weekday) == 'Saturday') { saturdays++; }
            if (dt.format(weekday) == 'Sunday'  ) { sundays++;   }
            if (californiaHolidays.containsKey(dt.format(yyyymmdd))) { holidays++;  }
            if (californiaHolidays.containsKey(dt.format(yyyymmdd)))
            {
                String s = '';
                s += dt.format(mmddyyyy) + ': ';
                s += californiaHolidays.get(dt.format(yyyymmdd)) + ' (';
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
        System.debug(('Date.valueOf(\'' + currentDate + '\').addDays(' + calendarDays + ') = ' + result).replace(' 00:00:00', ''));

        return result;
    }
}
