public class SRM_FindMatchingMetadata{
    
    private Id sprintId;
    private List<SRM_Metadata__c> metadataItems;
    
    public SRM_FindMatchingMetadata(Id sprintId, List<SRM_Metadata__c> metadataItems){
        this.sprintId = sprintId;
        this.metadataItems = metadataItems;
    }
    
    public void execute(){
        
        
        List<Id> mdIds = new List<Id>();
        List<String> mdTypes = new List<String>();
        List<String> members = new List<String>();
        Map<SRM_Metadata__c,List<SRM_Metadata__c>> mdToMatchingMd = new Map<SRM_Metadata__c,List<SRM_Metadata__c>>();
        
        for(SRM_Metadata__c md : metadataItems){
            
            mdIds.add(md.Id);
            mdTypes.add(md.Type__c);
            members.add(md.Name__c);
        }
        
        System.debug('Heres the metadata to be matched: '+JSON.serialize(metadataItems));
        
        List<SRM_Metadata__c> matchingMetadata = [SELECT Id, Name__c,Type__c,
                                                  Referenced_In_Another_Ticket__c,
                                                  Jira_Ticket__r.Owner__c,Referenced_In__c,
                                                  Jira_Ticket__r.Name, Jira_Ticket__r.CRM_Sprint__c
                                                  FROM SRM_Metadata__c WHERE Id NOT IN :mdIds
                                                  AND Name__c IN :members AND Type__c IN :mdTypes
                                                  AND Jira_Ticket__r.CRM_Sprint__c = :sprintId
                                                AND Jira_Ticket__r.Status__c = 'Awaiting Deployment' ];
        
        System.debug('Heres the matching md: '+JSON.serialize(matchingMetadata));
        
        
        for(SRM_Metadata__c md : metadataItems){
            
            for(SRM_Metadata__c matchingMd : matchingMetadata){
                
                if(isSameMdButDiffContext(md,matchingMd)){
                    
                    if(mdToMatchingMd.get(md) == null){
                        mdToMatchingMd.put(md,new List<SRM_Metadata__c>());
                    }
                    
                    mdToMatchingMd.get(md).add(matchingMd);
                    
                    System.debug('This is the same md but different owner');        
                }
                
            }
        }
        
        System.debug('Map of matching metadata: '+JSON.serializePretty(mdToMatchingMd));
        
        if(!mdToMatchingMd.isEmpty()){
            tagConflicts(mdToMatchingMd);
        }        
    }
    
    private Boolean isSameMdButDiffContext(SRM_Metadata__c md,SRM_Metadata__c matchingMd){
        
        System.debug('Evaluating if this is the same metadata but for a different owner');
        
        if(md.Name__c.equals(matchingMd.Name__c) && md.Type__c.equals(matchingMd.Type__c)){
            if(md.Jira_Ticket__r.Owner__c != matchingMd.Jira_Ticket__r.Owner__c){
                if(md.Jira_Ticket__c != matchingMd.Jira_Ticket__c){
                    return true;
                }
            }
        }
        
        return false;       
        
    }
    
    private void tagConflicts(Map<SRM_Metadata__c,List<SRM_Metadata__c>> mdToMatchingMd){
        
        System.debug('Starting to tag the conflicts');
        
        List<SRM_Metadata__c> recordsToUpdate = new List<SRM_Metadata__c>();
        
        for(SRM_Metadata__c md : mdToMatchingMd.keySet()){
            
            String mdWarningText = '';
            
            for(SRM_Metadata__c matchingMd : mdToMatchingMd.get(md)){
                
                mdWarningText += matchingMd.Jira_Ticket__r.Name+'('+matchingMd.Jira_Ticket__r.Owner__c+');';
                
                String matchingMdWarningText = md.Jira_Ticket__r.Name+'('+md.Jira_Ticket__r.Owner__c+');';
                
                if(matchingMd.Referenced_in__c == null){
                    matchingMd.Referenced_in__c = matchingMdWarningText;
                }else{
                    matchingMd.Referenced_in__c += matchingMdWarningText;
                }
                
                matchingMd.Referenced_in_another_ticket__c = true;
                
                System.debug('Warning text for the matching metadata: '+matchingMdWarningText);
                
                recordsToUpdate.add(matchingMd);
                
            } 
            
            System.debug('Warning text for this metadata: '+mdWarningText);
            
            md.Referenced_in_another_ticket__c = true;
            md.Referenced_in__c = mdWarningText;
            recordsToUpdate.add(md);
        }
        
        
        System.debug('The records to be updated: '+JSON.serializePretty(recordsToUpdate));
        
        if(recordsToUpdate.size() >0){
            update recordsToUpdate;
            System.debug('updated the records with no errors');
        }  
    }
    
}