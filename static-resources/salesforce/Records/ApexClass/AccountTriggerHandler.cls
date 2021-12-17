public class AccountTriggerHandler {
    
    public static void handleBeforeInsert(List<Account> newRecords){
        
        Account newAccount = newRecords[0];
        
        System.debug('BEFORE INSERT new account values - Name: '+newAccount.Name+' | Name Formula: '+newAccount.Name_Formula__c);
        
    } 
    
    public static void handleBeforeUpdate(Map<Id,Account> oldRecords,Map<Id,Account> newRecords){
        
        Account oldAccount = oldRecords.values()[0];
        Account newAccount = newRecords.values()[0];
        
        System.debug('BEFORE UPDATE old account values - Name: '+oldAccount.Name+' | Name Formula: '+oldAccount.Name_Formula__c);
        System.debug('BEFORE UPDATE new account values - Name: '+newAccount.Name+' | Name Formula: '+newAccount.Name_Formula__c);
        
    }

}