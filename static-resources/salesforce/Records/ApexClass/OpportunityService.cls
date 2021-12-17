public class OpportunityService {
    
    public static void doNothing(){
        System.debug([SELECT Related_Field__c FROM Field_referencing__mdt ]);
        
        System.debug([SELECT Id FROM Case WHERE Original_Deal__c != null]);
    }

}