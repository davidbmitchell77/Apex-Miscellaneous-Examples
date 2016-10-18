public class ApexSubClass extends ApexSuperClass {

    public ApexSubClass() {
        super();
    }

    public ApexSubClass(String salutation, String firstName, String lastName) {
        super(salutation, firstName, lastName);
    }

    public override void printName() {
        super.printName();
        System.debug('But you can call me ' + super.getFirstName() + '!');
    }
}