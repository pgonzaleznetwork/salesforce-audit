public class ClassWritingToField {
    
    public static void createAccount(){
        Account a = new Account(CustomerPriority__c='High');
        insert a;
       
    }

}