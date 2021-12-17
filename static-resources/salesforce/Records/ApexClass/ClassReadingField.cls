public class ClassReadingField {
    
    public static void hi(){
        
        Account acct = [SELECT Id, CustomerPriority__c FROM Account LIMIT 1];

        if(acct.CustomerPriority__c == 'High'){
            doSomething();
        }
        
        System.debug(nebc.ForEach.class); 
        
        List<Field_Referencing__mdt> mds = [SELECT Id, second_field__c FROM Field_referencing__mdt WHERE second_field__c != null];

		System.debug(mds);
    }

    public static void doSomething(){
        
    }

}