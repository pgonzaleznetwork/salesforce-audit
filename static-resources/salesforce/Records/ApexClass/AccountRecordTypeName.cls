public class AccountRecordTypeName {

    
    public static void doSomething(){
        
        List<Account> accounts = [SELECT RecordType.Name FROM Account];
        Account a = new Account();
        
    }
}