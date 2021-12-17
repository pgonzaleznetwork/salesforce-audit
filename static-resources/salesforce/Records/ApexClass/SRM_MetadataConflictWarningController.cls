public class SRM_MetadataConflictWarningController {
    
    private SRM_Jira_Ticket__c jiraTicket;
    private String warning = '';
    private String friendlyMessage = '';
    
    public SRM_MetadataConflictWarningController(ApexPages.StandardController con){
        
        jiraTicket = (SRM_Jira_Ticket__c) con.getRecord();
        
        SRM_Metadata_Conflict_Warning__mdt settings = [SELECT Friendly_Message__c,
                                                      Warning__c FROM SRM_Metadata_Conflict_Warning__mdt
                                                      WHERE DeveloperName = 'Default'];
        
        List<SRM_Metadata__c> mdItems = [SELECT Id FROM SRM_Metadata__c
                                         WHERE Jira_Ticket__c = :jiraTicket.Id
                                         AND Jira_Ticket__r.Status__c = 'Awaiting Deployment'
                                         AND Referenced_In_Another_Ticket__c = TRUE
                                         AND Type__c NOT IN ('Profile','CustomObject')];
        
        if(mdItems.size() > 0){
            warning = settings.Warning__c;
        }else{
            friendlyMessage = settings.Friendly_Message__c;
        }
        
    }
        
    public String getWarning(){

        return warning;
    }
    
    public String getFriendlyMessage(){

        return friendlyMessage;
        
    }

    /**************************************************************************** LEX METHODS ***************************************************************************/

    @AuraEnabled(cacheable=true)
    public static Result getText(Id deploymentId){

        SRM_Metadata_Conflict_Warning__mdt settings = [SELECT Friendly_Message__c,
                                                      Warning__c FROM SRM_Metadata_Conflict_Warning__mdt
                                                      WHERE DeveloperName = 'Default'];
        
        List<SRM_Metadata__c> mdItems = [SELECT Id FROM SRM_Metadata__c
                                         WHERE Jira_Ticket__c = :deploymentId
                                         AND Jira_Ticket__r.Status__c = 'Awaiting Deployment'
                                         AND Referenced_In_Another_Ticket__c = TRUE
                                         AND Type__c NOT IN ('Profile','CustomObject')];

        Result r = new Result();
        //by default we assume there are no conflicts
        r.conflicts = false;
        r.warning = settings.Friendly_Message__c;
        
        if(mdItems.size() > 0){
            r.conflicts = true;
            r.warning = settings.Warning__c;
        }

        return r;
        
    }

    public class Result{

        @AuraEnabled
        public Boolean conflicts;
        @AuraEnabled
        public String warning;

    }
    

}