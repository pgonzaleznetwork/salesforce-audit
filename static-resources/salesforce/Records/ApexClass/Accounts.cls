public with sharing class Accounts extends fflib_SObjectDomain {

    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public override void onApplyDefaults(){
        
        // Apply defaults to Testfflib_SObjectDomain
        for(Account a : (List<Account>) Records)
        {
            a.Description = 'Domain classes rock!';						
        }
    }
    
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

        for(Account a : (List<Account>) Records)
        {
            
            if (a.Description != null) {
                a.AnnualRevenue = a.Description.getLevenshteinDistance('Domain classes rock!');
            }
        }

    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
}