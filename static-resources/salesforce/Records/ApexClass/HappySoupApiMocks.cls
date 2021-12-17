/*
* Provides mock interfaces that represent all the available API calls in SRM_MetadataAPI_Client
* These are used as mock responses to these API calls in test classes.
*/
public class HappySoupApiMocks {
    
    
    public class DescribeMetadataResponse implements WebServiceMock {
        
        public String getResponseAsString(){
            return 'ApexClass';
        }
        
        public void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
            
            HappySoupMetadataApi.DescribeMetadataObject mdType = new HappySoupMetadataApi.DescribeMetadataObject();
            mdType.xmlName = 'ApexClass';
            
            HappySoupMetadataApi.DescribeMetadataResult describeResult = new HappySoupMetadataApi.DescribeMetadataResult();
            //describeResult.metadataObjects = new List<HappySoupMetadataApi.DescribeMetadataObject>{mdType};
                
                HappySoupMetadataApi.describeMetadataResponse_element responseElement = new HappySoupMetadataApi.describeMetadataResponse_element();
            //responseElement.result = describeResult;
            
            response.put('response_x', responseElement); 
        }
    }
    
    
    
    
    public class ListMetadataResponse implements WebServiceMock {
        
        public String getResponseAsString(){
            return 'FakeCustomFieldName';
        }
        
        public void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
            
            
            HappySoupMetadataApi.FileProperties fileProps = new HappySoupMetadataApi.FileProperties();
            fileProps.fullName = 'FakeCustomFieldName';
            
            List<HappySoupMetadataApi.FileProperties> filePropsList = new List<HappySoupMetadataApi.FileProperties>{fileProps};
                
                HappySoupMetadataApi.listMetadataResponse_element responseElement = new HappySoupMetadataApi.listMetadataResponse_element();
            //responseElement.result = filePropsList;
            
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