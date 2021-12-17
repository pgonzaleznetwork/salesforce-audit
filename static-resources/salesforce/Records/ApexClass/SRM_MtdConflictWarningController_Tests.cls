@IsTest
public class SRM_MtdConflictWarningController_Tests {
    
    
    
    @IsTest
    public static void testDisplayWarning(){
        
        SRM_TestData.insertTestData();
        
        SRM_Metadata_Conflict_Warning__mdt settings = [SELECT Friendly_Message__c,
                                                      Warning__c FROM SRM_Metadata_Conflict_Warning__mdt
                                                      WHERE DeveloperName = 'Default'];
        
        SRM_Jira_Ticket__c jiraTicket = [SELECT Id FROM SRM_Jira_Ticket__c LIMIT 1];
        
        SRM_Metadata__c md = new SRM_Metadata__c();
        md.Jira_Ticket__c = jiraTicket.Id;
        md.Type__c = 'ApexClass';
        md.Name__c = 'SampleClass';
        md.Referenced_in_another_ticket__c = true;
        
        insert md;
           
        ApexPages.StandardController controller = new ApexPages.StandardController(jiraTicket);
        
        Test.startTest();
        SRM_MetadataConflictWarningController extension = new SRM_MetadataConflictWarningController(controller);
        Test.stopTest();
     
        System.assert(extension.getFriendlyMessage() == '');
        System.assert(extension.getWarning() == settings.Warning__c);
        
    }
    
    @IsTest
    public static void testDisplayFriendlyMessage(){
        
        SRM_TestData.insertTestData();
        
        SRM_Metadata_Conflict_Warning__mdt settings = [SELECT Friendly_Message__c,
                                                      Warning__c FROM SRM_Metadata_Conflict_Warning__mdt
                                                      WHERE DeveloperName = 'Default'];
        
        SRM_Jira_Ticket__c jiraTicket = [SELECT Id FROM SRM_Jira_Ticket__c LIMIT 1];
                   
        ApexPages.StandardController controller = new ApexPages.StandardController(jiraTicket);
        
        Test.startTest();
        SRM_MetadataConflictWarningController extension = new SRM_MetadataConflictWarningController(controller);
        Test.stopTest();
            
        System.assert(extension.getFriendlyMessage() == settings.Friendly_Message__c);
        System.assert(extension.getWarning() == '');
        
    }

    @IsTest
    private static void testLEXMethod(){

        SRM_TestData.insertTestData();
        
        SRM_Jira_Ticket__c jiraTicket = [SELECT Id FROM SRM_Jira_Ticket__c LIMIT 1];

        SRM_MetadataConflictWarningController.Result result = SRM_MetadataConflictWarningController.getText(jiraTicket.Id);
        System.assert(!result.conflicts);

    }

}