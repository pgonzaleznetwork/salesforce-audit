public class MyStandardFields {
    
    public static void hello(){
        Account acct = new Account(Industry='yes');
   		acct.Name = 'Pablo';
        
        Opportunity a = [SELECT Name,StageName,Id,Account.ParentId FROM Opportunity WHERE IsWon = true LIMIT 1];
        
        List<Account> accounts = [SELECT Site,(SELECT Email,Id FROM Contacts WHERE AssistantName != null) 
                                  FROM Account WHERE Website  = 'HELLO'];
        
        String industryValue = 'hello';
        
        Account ac = [SELECT Id FROM Account WHERE Industry = :industryValue];
        
        //Lead l = new Lead(name='pablo');
        //l.Industry = 'test';
        
        /*Opportunity b = new Opportunity(ForecastCategory='hi')*/
    }

    
    
}