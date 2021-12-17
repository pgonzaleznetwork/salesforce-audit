@IsTest
public class SRM_MetadataConflict_Tests {
    
    @IsTest
    public static void testSameSprintSameOwner(){
        
        SRM_Metadata__c newMd = getMdSameSprintSameOwner();
        
        Test.startTest();
        insert newMd;
        Test.stopTest();
        
        List<SRM_Metadata__c> newMdItems = [SELECT Id, Referenced_In__c FROM SRM_Metadata__c];
        
        for(SRM_Metadata__c md : newMdItems){
            
            //System.assert(md.Referenced_in__c == null,'Should be null because metadata from the SAME owner'+
                        //  +' in the SAME Sprint should not be tagged as conflicting.');
        }      
    }
    
    @IsTest
    public static void testSameSprintDiffOwner(){
        
        SRM_Metadata__c newMd = getMdSameSprintDiffOwner();
        
        Test.startTest();
        insert newMd;
        Test.stopTest();
        
        newMd = [SELECT Id,Referenced_In__c,Jira_Ticket__r.Name FROM SRM_Metadata__c WHERE Id = :newMd.Id];
        SRM_Metadata__c existingMd = [SELECT Id,Referenced_In__c,Jira_Ticket__r.Name FROM SRM_Metadata__c WHERE Id != :newMd.Id];
      
        //System.assert(newMd.Referenced_in__c == 'CRM-0(David);');
     
    }
    
    
    
    /*****************************  TEST DATA CREATION METHODS ***************************************************/
    
    private static SRM_Metadata__c getMdSameSprintSameOwner(){
        
        SRM_CRM_Sprint__c sprint = new SRM_CRM_Sprint__c();
        sprint.Name = 'Sprint';
        
        insert sprint;
        
        SRM_Connected_Org__c org = new SRM_Connected_Org__c();
        org.Name = 'Sandbox';
        org.Named_Credential_Reference__c = 'callout:fakeNamedCredential';
        
        insert org;
        
        List<SRM_Jira_Ticket__c> jiraTickets = new List<SRM_Jira_Ticket__c>();
        
        
        for(Integer x=0; x < 2; x++){
            
            SRM_Jira_Ticket__c jiraTicket = new SRM_Jira_Ticket__c();
            jiraTicket.CRM_Sprint__c = sprint.Id;
            jiraTicket.Connected_Org__c = org.Id;
            jiraTicket.Owner__c = 'David';
            //jiraTicket.Name = 'CRM-'+x;
            jiraTickets.add(jiraTicket);
        }
        
        insert jiraTickets;
        
        List<SRM_Jira_Ticket__c> newJiraTickets = [SELECT Id FROM SRM_Jira_Ticket__c];
        
        List<SRM_Metadata__c> mdItems = new List<SRM_Metadata__c>();
        
        SRM_Metadata__c existingMd = new SRM_Metadata__c();
        existingMd.Type__c = 'ApexClass';
        existingMd.Name__c = 'MySampleClass';
        existingMd.Jira_Ticket__c = newJiraTickets[0].Id;
        
        insert existingMd;
        
        SRM_Metadata__c newMd = new SRM_Metadata__c();
        newMd.Type__c = 'ApexClass';
        newMd.Name__c = 'MySampleClass';
        newMd.Jira_Ticket__c = newJiraTickets[0].Id;
        
        return newMd;
    }
    
    private static SRM_Metadata__c getMdSameSprintDiffOwner(){
        SRM_CRM_Sprint__c sprint = new SRM_CRM_Sprint__c();
        sprint.Name = 'Sprint';
        
        insert sprint;
        
        SRM_Connected_Org__c org = new SRM_Connected_Org__c();
        org.Name = 'Sandbox';
        org.Named_Credential_Reference__c = 'callout:fakeNamedCredential';
        
        insert org;
        
        List<SRM_Jira_Ticket__c> jiraTickets = new List<SRM_Jira_Ticket__c>();
        
        
        for(Integer x=0; x < 2; x++){
            
            SRM_Jira_Ticket__c jiraTicket = new SRM_Jira_Ticket__c();
            jiraTicket.CRM_Sprint__c = sprint.Id;
            jiraTicket.Connected_Org__c = org.Id;
            jiraTicket.Owner__c = x==0 ? 'David' : 'Regina';
            //jiraTicket.Name = 'CRM-'+x;
            jiraTickets.add(jiraTicket);
        }
        
        insert jiraTickets;
               
        SRM_Metadata__c existingMd = new SRM_Metadata__c();
        existingMd.Type__c = 'ApexClass';
        existingMd.Name__c = 'MySampleClass';
        existingMd.Jira_Ticket__c = jiraTickets[0].Id;
        
        insert existingMd;
        
        System.debug('EXISTING TEST DATA CONTEXT');
        
        SRM_Metadata__c newMd = new SRM_Metadata__c();
        newMd.Type__c = 'ApexClass';
        newMd.Name__c = 'MySampleClass';
        newMd.Jira_Ticket__c = jiraTickets[1].Id;
    
        return newMd;
    } 
}