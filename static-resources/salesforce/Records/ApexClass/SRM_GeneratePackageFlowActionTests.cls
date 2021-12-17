@IsTest
public class SRM_GeneratePackageFlowActionTests {
    
    
    @TestSetup
    private static void createRecords(){  
        SRM_TestData.insertTestData();   
    }
    
    @IsTest
    public static void testAttachToJiraTicket(){

        SRM_Jira_Ticket__c jiraTicket = [SELECT Id,Name FROM SRM_Jira_Ticket__c LIMIT 1];
        List<SRM_Metadata__c> mdItems = [SELECT Id,Name__c,Type__c FROM SRM_Metadata__c WHERE Jira_Ticket__c = :jiraTicket.Id];

        SRM_GeneratePackageFlowAction req = new SRM_GeneratePackageFlowAction();

        req.recordId = jiraTicket.Id;
        req.mdItems = mdItems;
        req.fileName = 'myfilename';

        Test.startTest();
        SRM_GeneratePackageFlowAction.generatePackage(new List<SRM_GeneratePackageFlowAction>{req});
        Test.stopTest();
                
        List<Attachment> attachments = [SELECT Id,Name FROM Attachment WHERE ParentId = :jiraTicket.Id];
        
        System.assert(attachments.size() > 0);
        System.assert(attachments[0].Name == 'myfilename');
        
        
    }
    
    @IsTest
    public static void testAttachToCRMSprint(){
        
        SRM_CRM_Sprint__c crmSprint = [SELECT Id,Name FROM SRM_CRM_Sprint__c LIMIT 1];
        List<SRM_Metadata__c> mdItems = [SELECT Id,Name__c,Type__c FROM SRM_Metadata__c WHERE Sprint_Id__c = :crmSprint.Id];

        SRM_GeneratePackageFlowAction req = new SRM_GeneratePackageFlowAction();

        req.recordId = crmSprint.Id;
        req.mdItems = mdItems;
        req.fileName = 'myfilename';

        Test.startTest();
        SRM_GeneratePackageFlowAction.generatePackage(new List<SRM_GeneratePackageFlowAction>{req});
        Test.stopTest();
                
        List<Attachment> attachments = [SELECT Id,Name FROM Attachment WHERE ParentId = :crmSprint.Id];
        
        System.assert(attachments.size() > 0);
        System.assert(attachments[0].Name == 'myfilename'); 
    }
}