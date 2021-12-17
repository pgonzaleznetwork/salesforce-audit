@IsTest
public class SRM_SelectMetadataExtensionTests {
    
    @TestSetup
    public static void createTestRecord(){ 
        SRM_TestData.insertTestData();   
    }
    
   @IsTest
    public static void testGetterMethods(){
                
        SRM_Jira_Ticket__c jiraTicket = [SELECT Id,Name,Connected_Org__r.Named_Credential_Reference__c,crm_Sprint__r.Name 
                                     FROM SRM_Jira_Ticket__c LIMIT 1];

        ApexPages.StandardController stdController = new ApexPages.StandardController(jiraTicket); 
        SRM_SelectMetadataExtension extension = new SRM_SelectMetadataExtension(stdController);

        
        System.assert(extension.getNamedCredential() == 'callout:fakeNamedCredential');
        System.assert(extension.getCrmSprint() == 'Sprint');
        System.debug('provided by code: '+extension.getReturnUrl());
        System.debug('expected: '+URL.getOrgDomainUrl().toExternalForm()+'/'+jiraTicket.Id);
        System.assert(extension.getReturnUrl() == URL.getOrgDomainUrl().toExternalForm()+'/'+jiraTicket.Id);
        System.assert(extension.getParentId() == jiraTicket.Id);
        
    }
    
    @IsTest
    public static void testGetMetadataTypes(){
        
        Test.startTest();
        
        SRM_MetadataApiMocks.DescribeMetadataResponse mdApiMock = new SRM_MetadataApiMocks.DescribeMetadataResponse();
        
        Test.setMock(WebServiceMock.class, mdApiMock);
        
        List<String> metadataTypes = SRM_SelectMetadataExtension.getMetadataTypes('callout:fakeNamedCredential');
        
        Test.stopTest();
        
        System.assert(metadataTypes[0] == mdApiMock.getResponseAsString());
    }
    
    @IsTest
    public static void testGetFilteredMembers(){
        
        Test.startTest();
        
        SRM_MetadataApiMocks.ListMetadataResponse mdApiMock = new SRM_MetadataApiMocks.ListMetadataResponse();
        
        Test.setMock(WebServiceMock.class,mdApiMock);
        
        List<String> members = SRM_SelectMetadataExtension.getFilteredMembers('callout:fakeNamedCredential','CustomField');
        
        Test.stopTest();
        
        System.assert(members[0] == mdApiMock.getResponseAsString());
    }
        
}