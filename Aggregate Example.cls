for (AggregateResult agr : [SELECT Account.Name,
                                   MAX(ExpectedRevenue) MaxExpectedRevenue,
                                   MIN(ExpectedRevenue) MinExpectedRevenue,
                                   AVG(ExpectedRevenue) AvgExpectedRevenue,
                                   SUM(ExpectedRevenue) SumExpectedRevenue,
                                   COUNT(Id)
                              FROM Opportunity
                             WHERE Account.Name != null
                            GROUP BY Account.Name
                            ORDER BY MAX(ExpectedRevenue) DESC
    
]) {
    String s = '';
    s += (String)agr.get('Name');
    s += ': $' + ((Decimal)agr.get('MaxExpectedRevenue')).format() + '.00 ';
    s += UserInfo.getDefaultCurrency() + ' ';
    s += ': $' + ((Decimal)agr.get('MinExpectedRevenue')).format() + '.00 ';
    s += UserInfo.getDefaultCurrency() + ' ';
    s += ': $' + ((Decimal)agr.get('AvgExpectedRevenue')).format() + '.00 ';
    s += UserInfo.getDefaultCurrency() + ' ';
    s += ': $' + ((Decimal)agr.get('SumExpectedRevenue')).format() + '.00 ';
    s += (Integer)agr.get('expr0');
    System.debug(LoggingLevel.INFO, s);
}
