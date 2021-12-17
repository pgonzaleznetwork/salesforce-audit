/*
* 
* Trigger handler class for the SRM_Metadata__c object. This represents a specific Salesforce metadata item, for example a page layout, or a custom field.
*
* Inside a specific trigger context method, use the methods of the TriggerUtils_TriggerStatus instance to return immediately if that particular context is disabled.
*
* CHANGE LOG - To view the specific details of the changes go to https://github.com/websummit/sfdc/tree/dev/src/classes
*
*/
public class SRM_MetadataTriggerHandler {
    
    private static TriggerUtils_TriggerStatus triggerStatus = new TriggerUtils_TriggerStatus('SRM_Metadata__c');
    
    public static void afterInsert(Map<Id,SRM_Metadata__c> newRecords){
        
        if(!triggerStatus.afterInsertEnabled()){return;}
        
        SRM_MetadataConflict.process(newRecords.keySet());
    }

}