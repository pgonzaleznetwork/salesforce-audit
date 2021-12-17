public with sharing class CaseService {
    
    public static void closeCases(Set<Id> ids,String reason){

        List<Case> cases = [SELECT Id,Reason FROM Case WHERE Id IN :ids];
        if (cases.isEmpty()) return;

        for (Case c : cases) {
            c.Reason = reason;
            c.Status = 'Closed';
        }

        update cases;
        
    }

}