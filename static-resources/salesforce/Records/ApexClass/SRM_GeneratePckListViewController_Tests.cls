@IsTest
public class SRM_GeneratePckListViewController_Tests {
    
    @TestSetup
    public static void createTestData(){
        SRM_TestData.insertTestData();
    }
    
    @IsTest
    public static void testGeneratePackage(){
        
        List<SRM_Jira_Ticket__c> jiraTickets = [SELECT Id FROM SRM_Jira_Ticket__c];
        
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(jiraTickets);
        stdController.setSelected(jiraTickets);
        
        SRM_GeneratePackageListViewConttroller controller = new SRM_GeneratePackageListViewConttroller(stdController);
        
        controller.generatePackage();
        
        Folder folder = [SELECT Id FROM Folder WHERE DeveloperName = 'SRM_Packages' LIMIT 1];
        
        System.assert(folder != null);
        
        Document doc = [SELECT Name FROM Document WHERE FolderId = :folder.Id LIMIT 1];
        
        System.assert(doc != null);
        System.assert(doc.Name.contains('package.xml'));
      
    }

}