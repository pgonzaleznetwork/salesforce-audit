public class OpportunityTriggerHelper {
    
    public static void doSomething(){
        Opportunity o = new Opportunity();
        if(o.Account_Priority__c  != null){
            //do something
        }
        
        Account a = new Account(BillingCity=null);
        
        if(o.My_Lookup_Field__c   != null){
            //do something
        }
        
        if(o.My_Picklist_Field__c != null){
            //more
        }
        
        OpportunityService.doNothing();
    }

}