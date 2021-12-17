/*
* Represents a SOAP API Client that uses the Metadata API to query and describe metadata from a connected org.
*/
public class SRM_MetadataApiProxy {
    
    private final SRM_API_Metadata_Client_Setting__mdt settings;
    
    private final double API_VERSION;
    private final string ENDPOINT;
    
    List<String> additionalMetadataTypes;
    private String namedCredential;
    
    
    public SRM_MetadataApiProxy(String namedCredential){
        
        settings = [SELECT Endpoint__c, Api_Version__c, Additional_Metadata_Types__c,
                    Describe_Metadata_Exception__c,List_Metadata_Exception__c FROM SRM_API_Metadata_Client_Setting__mdt
                    WHERE DeveloperName  = 'Default' LIMIT 1];
        
        API_VERSION =  Decimal.valueOf(settings.Api_Version__c);
        ENDPOINT = settings.Endpoint__c+API_VERSION;
        additionalMetadataTypes = settings.Additional_Metadata_Types__c.split(',');
        
        this.namedCredential = namedCredential;     
    }
     
    /*
    * Returns a list of strings that represent most of the metadata types available in the connected org. Some metadata types
    * are not available through this API call, so they are added as additional metadata types stored in Custom Metadata.
    */
    public List<String> describeMetadata(){
        
        SRM_MetadataAPI.DescribeMetadataResult describeResult;
        
        try{
            describeResult = getDescribeMetadataResult(API_VERSION,false);
        }catch(Exception e){
            throw new DescribeMetadataException(settings.Describe_Metadata_Exception__c,e);      
        }
        
        List<String> metadataTypes = new List<String>();
        
        
        for(SRM_MetadataAPI.DescribeMetadataObject mdObject : describeResult.metadataObjects){
            metadataTypes.add(mdObject.xmlName);
        }
        
        for(String mdType : additionalMetadataTypes){
            metadataTypes.add(mdType);
        }
        
        metadataTypes.sort();
        
        return metadataTypes;
    }
    
    /*
     * Due to a documented Salesforce bug, API calls can fail due to an old session Id that the NamedCredential infrastructure
     * is unable to renew. The following methods attempts to renew the session id when the API first fails, and throws
     * an exception if the API call fails for a 2nd time
	*/
    private SRM_MetadataAPI.DescribeMetadataResult getDescribeMetadataResult(double apiVersion,Boolean wasCalledRecursively){
        
        SRM_MetadataAPI.Metadata mdApi = getAuthenticatedApi();          
        SRM_MetadataAPI.DescribeMetadataResult describeResult;
        
        try{
            describeResult =  mdApi.describeMetadata(apiVersion);
        }catch(Exception e){
            
            if(!wasCalledRecursively){
                resetSessionId();
                describeResult = getDescribeMetadataResult(apiVersion,true);
            }else{
                throw e;
            }
        }
        return describeResult;    
    }
    
    /*
    * Instantiates a SOAP client that can call the Metadata API in the connected org. It uses the OAuthToken credential
    * to reference the connected org through a named credential.
    */
    
    private SRM_MetadataAPI.Metadata getAuthenticatedApi(){
        
        SRM_MetadataAPI.Metadata mdApi = new SRM_MetadataAPI.Metadata();
        mdApi.endpoint_x = namedCredential+ENDPOINT;
        mdApi.sessionHeader = new SRM_MetadataAPI.SessionHeader_element();
        mdApi.sessionHeader.sessionId = '{!$Credential.OAuthToken}';
        return mdApi;
    }
    
    
    /*
    * Returns a list of strings that represent all the members of a given metadata type, for example, it can return all the custom fields in the org
    * if the CustomField parameter is passed. 
    */
    public List<String> listMetadata(String metadataType){
            
        SRM_MetadataAPI.ListMetadataQuery query = new SRM_MetadataAPI.ListMetadataQuery();
        query.type_x = metadataType;
        
        
        List<SRM_MetadataAPI.ListMetadataQuery> queries = new List<SRM_MetadataAPI.ListMetadataQuery>{query};
        List<SRM_MetadataAPI.FileProperties> results;
            
            try{
                 results = getFileProperties(queries,API_VERSION,false);
            }catch(Exception e){
                throw new ListMetadataException(settings.List_Metadata_Exception__c,e);
            }
           
        List<String> metadataNames = new List<String>();
        
        for(SRM_MetadataAPI.FileProperties result : results){
            metadataNames.add(result.fullName);
        }
        
        metadataNames.sort();
        
        return metadataNames;
    }
    
    /*
     * Due to a documented Salesforce bug, API calls can fail due to an old session Id that the NamedCredential infrastructure
     * is unable to renew. The following methods attempts to renew the session id when the API first fails, and throws
     * an exception if the API call fails for a 2nd time
	*/
    private List<SRM_MetadataAPI.FileProperties> getFileProperties(List<SRM_MetadataAPI.ListMetadataQuery> queries,Double apiVersion,Boolean wasCalledRecursively){
        
        SRM_MetadataAPI.Metadata mdApi = getAuthenticatedApi();                                                                  
        
        List<SRM_MetadataAPI.FileProperties> results;
        
        try{
            results = mdApi.listMetadata(queries, apiVersion);
        }catch(Exception e){
            if(!wasCalledRecursively){
                resetSessionId();
                results = mdApi.listMetadata(queries, apiVersion);
            }else{
                throw e;
            }
        }
        
        return results;                                                         
    }
    
   
    
    /*
    * This is a hack to reset the session Id. This is needed due to a documented bug in the Named Credential infrastructure.
    * More details at: https://help.salesforce.com/articleView?id=000264621&language=en_US&type=1
    */
    @TestVisible
    private void resetSessionId(){
        
        System.debug('resetSessionId was called');
        
        String restUrl = namedCredential+'/services/data/v39.0/limits';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(restUrl);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
    }
    
    public class DescribeMetadataException extends Exception{}
    public class ListMetadataException extends Exception{}
    
}