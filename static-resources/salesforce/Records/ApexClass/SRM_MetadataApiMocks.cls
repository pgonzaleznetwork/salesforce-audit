/*
* Provides mock interfaces that represent all the available API calls in SRM_MetadataAPI_Client
* These are used as mock responses to these API calls in test classes.
*/
public class SRM_MetadataApiMocks {
    
    
    public class DescribeMetadataResponse implements WebServiceMock {
        
        public String getResponseAsString(){
            return 'ApexClass';
        }
        
        public void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
            
            SRM_MetadataAPI.DescribeMetadataObject mdType = new SRM_MetadataAPI.DescribeMetadataObject();
            mdType.xmlName = 'ApexClass';
            
            SRM_MetadataAPI.DescribeMetadataResult describeResult = new SRM_MetadataAPI.DescribeMetadataResult();
            describeResult.metadataObjects = new List<SRM_MetadataAPI.DescribeMetadataObject>{mdType};
                
                SRM_MetadataAPI.describeMetadataResponse_element responseElement = new SRM_MetadataAPI.describeMetadataResponse_element();
            responseElement.result = describeResult;
            
            response.put('response_x', responseElement); 
        }
    }
    
    
    
    
    public class ListMetadataResponse implements WebServiceMock {
        
        public String getResponseAsString(){
            return 'FakeCustomFieldName';
        }
        
        public void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
            
            
            SRM_MetadataAPI.FileProperties fileProps = new SRM_MetadataAPI.FileProperties();
            fileProps.fullName = 'FakeCustomFieldName';
            
            List<SRM_MetadataAPI.FileProperties> filePropsList = new List<SRM_MetadataAPI.FileProperties>{fileProps};
                
                SRM_MetadataAPI.listMetadataResponse_element responseElement = new SRM_MetadataAPI.listMetadataResponse_element();
            responseElement.result = filePropsList;
            
            response.put('response_x', responseElement); 
        }
    }
    
    
    public class ResetSessionIdResponse implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"Session Id":"FakeId"}');
            response.setStatusCode(200);
            
            return response;
            
        }
    }
    
}