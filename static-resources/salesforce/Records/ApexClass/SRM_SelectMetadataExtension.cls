/*
 * Visualforce controller for SRM_SelectMetadata.vfp. 
*/
public class SRM_SelectMetadataExtension {
    
    private String jiraTicketNumber;
    private string crmSprint;
    private  String namedCredential;
    private Id parentId;
    
    
   public SRM_SelectMetadataExtension(ApexPages.StandardController stdController){
        
        parentId = stdController.getId();
        SRM_Jira_Ticket__c jiraTicket = [SELECT Name,Connected_Org__r.Named_Credential_Reference__c,crm_Sprint__r.Name 
                                     FROM SRM_Jira_Ticket__c WHERE Id = :parentId LIMIT 1];
        jiraTicketNumber = jiraTicket.Name;
        crmSprint = jiraTicket.CRM_Sprint__r.Name;
        namedCredential = jiraTicket.Connected_Org__r.Named_Credential_Reference__c;
        
    }
    
    
    public String getNamedCredential(){
        return namedCredential;
    }
    
    public String getJiraTicketNumber(){
        return jiraTicketNumber;
    }
    
    public String getCrmSprint(){
        return crmSprint;
    }
    
    public String getReturnUrl(){
        
        String domain = URL.getOrgDomainUrl().toExternalForm();
        //String parentId = ApexPages.currentPage().getParameters().get('parentId');
        
        return domain+'/'+parentId;
    }
    
    public String getParentId(){
        //String parentId = ApexPages.currentPage().getParameters().get('parentId');
        return parentId;
    }
        
        
    @RemoteAction
    public static List<String> getFilteredMembers(String namedCredential,String mdType){
                
        return new SRM_MetadataApiProxy(namedCredential).ListMetadata(mdType);
    }
        
    @RemoteAction
    public static List<String> getMetadataTypes(String namedCredential){
  
        return new SRM_MetadataApiProxy(namedCredential).describeMetadata();
    }   
}