public class SRM_MetadataConflict {
    
    
    public static void process(Set<Id> metadataIds){
        
        System.debug('Ids of new metadata: '+JSON.serialize(metadataIds));
        
        Map<Id,List<SRM_Metadata__c>> mdBySprintId = sortBySprintId(metadataIds);
        
        System.debug('Successfully sorted by sprintid');
        
        for(Id sprintId : mdBySprintId.keySet()){
            
            System.debug('Enqueuing the jobs');
            
            SRM_FindMatchingMetadata job = new SRM_FindMatchingMetadata(sprintId,mdBySprintId.get(sprintId));
            job.execute();
        } 
    }
    
    @TestVisible
    private static Map<Id,List<SRM_Metadata__c>> sortBySprintId(Set<Id> metadataIds){
        
        System.debug('Sorting by Sprint id');
        
        List<SRM_Metadata__c> mds = [SELECT Id, Name__c,Type__c,Referenced_In_Another_Ticket__c, 
                                     Jira_Ticket__r.Owner__c,Referenced_In__c,
                                     Jira_Ticket__r.Name, Jira_Ticket__r.CRM_Sprint__c
                                     FROM SRM_Metadata__c WHERE Id IN :metadataIds];
        
        

        Map<Id,List<SRM_Metadata__c>> mdBySprintId = Utils_Apex.mapRecordsByCustomId('Jira_Ticket__r.CRM_Sprint__c',mds);
        
        /*Map<Id,List<SRM_Metadata__c>> mdBySprintId = new Map<Id,List<SRM_Metadata__c>>();
        
        for(SRM_Metadata__c md : mds){
            
            //if an entry doesn't already exist for this sprint
            if(mdBySprintId.get(md.Jira_Ticket__r.CRM_Sprint__c) == null){
                //create an entry to store md items by sprint id
                mdBySprintId.put(md.Jira_Ticket__r.CRM_Sprint__c,new List<SRM_Metadata__c>());    
            }
            
             // add the md item to the list for that sprint
              mdBySprintId.get(md.Jira_Ticket__r.CRM_Sprint__c).add(md);
               
        }*/
        
        System.debug('The map of md by sprint Id: '+JSON.serializePretty(mdBySprintId));
        
        return mdBySprintId;  
    } 
}