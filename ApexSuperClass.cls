public virtual class ApexSuperClass {

    public String mySalutation;
    public String myFirstName;
    public String myLastName;

    public ApexSuperClass() {
        mySalutation = 'Mr.';
        myFirstName = 'Carl';
        myLastName = 'Vonderburg';
    }

    public ApexSuperClass(String salutation, String firstName, String lastName) {
        mySalutation = salutation;
        myFirstName = firstName;
        myLastName = lastName;
    }

    public virtual void printName() {
        System.debug('My name is ' + mySalutation + ' ' + myLastName + '.');
    }

   public virtual String getFirstName() {
       return myFirstName;
   }
}