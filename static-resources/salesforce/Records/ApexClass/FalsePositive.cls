public class FalsePositive {
    
    public static void main(){
        Account a = new Account();
        if(a.CustomerPriority__c == null){
            //decision
        }
        //a.CustomerPriority__c = 'new value' << this should not be considered a write because its a comment
        //
        Opportunity o = new Opportunity();
        //o.StageName = 'new value'; this should be ignored
    }
    
    

}