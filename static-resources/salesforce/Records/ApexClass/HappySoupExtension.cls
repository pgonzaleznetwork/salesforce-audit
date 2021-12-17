@IsTest
public class HappySoupExtension {
    
    @TestSetup
    public static void createTestRecord(){ 
        HappySoupTestData.insertTestData();   
    }
    
   @IsTest
    public static void testGetterMethods(){
                
        SRM_Jira_Ticket__c jiraTicket = [SELECT Id,Name,Connected_Org__r.Named_Credential_Reference__c,crm_Sprint__r.Name 
                                     FROM SRM_Jira_Ticket__c LIMIT 1];

        ApexPages.StandardController stdController = new ApexPages.StandardController(jiraTicket); 
        HappySoupExtensionController extension = new HappySoupExtensionController(stdController);

        
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
        
        HappySoupApiMocks.DescribeMetadataResponse mdApiMock = new HappySoupApiMocks.DescribeMetadataResponse();
        
        Test.setMock(WebServiceMock.class, mdApiMock);
        
        List<String> metadataTypes = HappySoupExtensionController.getMetadataTypes('callout:fakeNamedCredential');
        
        Test.stopTest();
        
        System.assert(metadataTypes[0] == mdApiMock.getResponseAsString());
    }
    
    @IsTest
    public static void testGetFilteredMembers(){
        
        Test.startTest();
        
        HappySoupApiMocks.ListMetadataResponse mdApiMock = new HappySoupApiMocks.ListMetadataResponse();
        
        Test.setMock(WebServiceMock.class,mdApiMock);
        
        List<String> members = HappySoupExtensionController.getFilteredMembers('callout:fakeNamedCredential','CustomField');
        
        Test.stopTest();
        
        System.assert(members[0] == mdApiMock.getResponseAsString());
    }
        
}