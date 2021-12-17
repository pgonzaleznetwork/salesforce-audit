public with sharing class RightAClass {

    public RightAClass() {

        List<Lead_To_Oppty_Mapping__mdt> mtd = [
            SELECT Lead_Field__c, Opportunity_Field__c
            FROM Lead_To_Oppty_Mapping__mdt
        ];

    }
}