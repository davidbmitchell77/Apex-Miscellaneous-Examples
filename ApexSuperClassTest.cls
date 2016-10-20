@isTest
private class ApexSuperClassTest {

    static TestMethod void myTest() {
    	String salutation = 'Mr.';
    	String firstName = UserInfo.getFirstName();
    	String lastName = UserInfo.getLastName();

        Test.startTest();
        ApexSubClass asub1 = new ApexSubClass();
        asub1.printName();
        ApexSubClass asub2 = new ApexSubClass(salutation, firstName, lastName);
        asub2.printName();
        Test.stopTest();
    }
}
