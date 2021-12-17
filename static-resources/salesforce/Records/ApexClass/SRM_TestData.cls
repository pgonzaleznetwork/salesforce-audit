public class SRM_TestData {
    
    public static void insertTestData(){
        
        SRM_CRM_Sprint__c sprint = new SRM_CRM_Sprint__c();
        sprint.Name = 'Sprint';
        
        insert sprint;
        
        SRM_Connected_Org__c org = new SRM_Connected_Org__c();
        org.Name = 'Sandbox';
        org.Named_Credential_Reference__c = 'callout:fakeNamedCredential';
        
        insert org;
        
        SRM_Jira_Ticket__c jiraTicket = new SRM_Jira_Ticket__c();
        jiraTicket.CRM_Sprint__c = sprint.Id;
        jiraTicket.Connected_Org__c = org.Id;
        
        insert jiraTicket;
        
        List<SRM_Metadata__c> mdItems = new List<SRM_Metadata__c>();
        
  
        for(Integer x=0; x < 4; x++){
            
            SRM_Metadata__c md = new SRM_Metadata__c();
            md.Type__c = 'ApexClass';
            md.Name__c = 'MySampleClass'+x;
            md.Jira_Ticket__c = jiraTicket.Id;
            mdItems.add(md);
        }
        
        insert mdItems;
    }
}