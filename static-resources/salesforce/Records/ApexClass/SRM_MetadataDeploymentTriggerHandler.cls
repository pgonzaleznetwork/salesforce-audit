/*
* 
* Trigger handler class for the SRM_Jira_Ticket__c object. This object used to represent a jira ticket, but it now represents a metadata deployment. 
* This is because the CRM team no longer uses Jira, and instead uses Cases. 
*
* Inside a specific trigger context method, use the methods of the TriggerUtils_TriggerStatus instance to return immediately if that particular context is disabled.
*
*/
public class SRM_MetadataDeploymentTriggerHandler {
    
    private static TriggerUtils_TriggerStatus triggerStatus = new TriggerUtils_TriggerStatus('SRM_Jira_Ticket__c');
    
    /**************************************************************** PUBLIC METHODS *****************************************/
    
    public static void beforeUpdate(Map<Id,SRM_Jira_Ticket__c> oldRecords,Map<Id,SRM_Jira_Ticket__c> newRecords){
        
        if(!triggerStatus.afterUpdateEnabled()){return;}
        
        fireNewApexCodeNotification(oldRecords,newRecords);
        
    }
    
    /**************************************************************** PRIVATE/IMPLEMENTATION METHODS *****************************************/
    
    /*
* Sets two fields on the deployment record when the deployment is closed and if it contains apex classes or triggers.
* The actual notification is done by a workflow rule, and it goes out to the CRM team. The idea is to let them know that new
* apex code has been deployed/changed and so they need to rebase those changes into their sandbox. 
*/
    private static void fireNewApexCodeNotification(Map<Id,SRM_Jira_Ticket__c> oldRecords,Map<Id,SRM_Jira_Ticket__c> newRecords){
        
        Map<Id,SRM_Jira_Ticket__c> closedDeployments = new Map<Id,SRM_Jira_Ticket__c>();
        
        for(SRM_Jira_Ticket__c deployment : newRecords.values()){
            Boolean hasBeenDeployed = deployment.Status__c.equals('Deployed') && !oldRecords.get(deployment.Id).Status__c.equals('Deployed');
            
            if(hasBeenDeployed){
                closedDeployments.put(deployment.Id,deployment);
            }
        }
        
        if(!closedDeployments.isEmpty()){
            
            Set<String> apexTypes = new Set<String>();
            apexTypes.add('ApexClass');
            apexTypes.add('ApexTrigger');
            
            List<SRM_Jira_Ticket__c> deploymentsWithApex = [SELECT Id, (SELECT Name__c , Jira_Ticket__c FROM Metadata__r WHERE  Type__c IN :apexTypes) FROM SRM_Jira_Ticket__c WHERE Id IN :closedDeployments.keySet()];
            
            for(SRM_Jira_Ticket__c deployment : deploymentsWithApex){
                
                if(!deployment.Metadata__r.isEmpty()){
                    
                    SRM_Jira_Ticket__c closedDeployment = closedDeployments.get(deployment.Id);//get the reference from the trigger context so that we can set the fields
                    
                    String apexNames = '';
                    
                    for(SRM_Metadata__c md : deployment.Metadata__r){
                        apexNames += md.Name__c+',';
                    }
                    
                    apexNames = apexNames.substringBeforeLast(',');//remove the left over comma.
                    
                    closedDeployment.Deployed_Apex_Names__c = apexNames;
                    closedDeployment.Fire_New_Apex_Notification__c = true;
                    
                }   
            }
        }
        
    }
    
}