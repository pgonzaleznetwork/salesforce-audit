@IsTest
public class SRM_MetadataApiProxy_Tests {
    
    @IsTest
    public static void testDescribe(){
        
        SRM_MetadataApiMocks.DescribeMetadataResponse mdApiMock = new  SRM_MetadataApiMocks.DescribeMetadataResponse();

        Test.setMock(WebServiceMock.class, mdApiMock);
        
        SRM_MetadataApiProxy mdApi = new SRM_MetadataApiProxy('callout:fakeNamedCredential');
        
        List<String> metadataTypes = mdApi.describeMetadata();
        
        System.assert(metadataTypes[0] == mdApiMock.getResponseAsString());
        
    }
    
    @IsTest
    public static void testListMetadata(){
        
        SRM_MetadataApiMocks.ListMetadataResponse mdApiMock = new SRM_MetadataApiMocks.ListMetadataResponse();
        
        Test.setMock(WebServiceMock.class, mdApiMock);
        
        SRM_MetadataApiProxy mdApi = new SRM_MetadataApiProxy('callout:fakeNamedCredential');
        
        List<String> mdMembers = mdApi.listMetadata('CustomField');
        
        System.assert(mdMembers[0] == mdApiMock.getResponseAsString());
        
    }   
    
    @IsTest
    public static void testResetSessionId(){
        
         Test.setMock(HttpCalloutMock.class, new SRM_MetadataApiMocks.ResetSessionIdResponse());
        
         SRM_MetadataApiProxy mdApi = new SRM_MetadataApiProxy('callout:fakeNamedCredential');
        
         mdApi.resetSessionId();
        
        //there's nothing to test here because the above method is a hack to prevent a Salesforce bug. Read the mdApi code for details.
    }
}