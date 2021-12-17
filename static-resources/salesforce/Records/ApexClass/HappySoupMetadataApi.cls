/*
 * This class is the output of the parsed Metadata API WSDL. It allows client code to use the Metadata API to query its own metadata
 * or the metadata of another org.
 * 
 * This class should not be modified unless a new API call needs to be supported. Any other functionality should be implemented by the client code.
*/
public class HappySoupMetadataApi {
    
        public class Metadata {
        
        //public String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/42.0';
        public String endpoint_x = 'callout:PartialOrgCredential';//SHOULD CHANGE DYNAMICALLY BASED ON THE ORG
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public SRM_MetadataAPI.SessionHeader_element SessionHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'SRM_MetadataAPI'};
                
        
        public SRM_MetadataAPI.DescribeMetadataResult describeMetadata(Double asOfVersion) {
            SRM_MetadataAPI.describeMetadata_element request_x = new SRM_MetadataAPI.describeMetadata_element();
            request_x.asOfVersion = asOfVersion;
            SRM_MetadataAPI.describeMetadataResponse_element response_x;
            Map<String, SRM_MetadataAPI.describeMetadataResponse_element> response_map_x = new Map<String, SRM_MetadataAPI.describeMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'describeMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'describeMetadataResponse',
              'SRM_MetadataAPI.describeMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
   
        
        public SRM_MetadataAPI.FileProperties[] listMetadata(SRM_MetadataAPI.ListMetadataQuery[] queries,Double asOfVersion) {
            SRM_MetadataAPI.listMetadata_element request_x = new SRM_MetadataAPI.listMetadata_element();
            request_x.queries = queries;
            request_x.asOfVersion = asOfVersion;
            SRM_MetadataAPI.listMetadataResponse_element response_x;
            Map<String, SRM_MetadataAPI.listMetadataResponse_element> response_map_x = new Map<String, SRM_MetadataAPI.listMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadataResponse',
              'SRM_MetadataAPI.listMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
    
    /************************************************** SERVICE HTTP HEADER CLASSES *******************************************/

    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
      
    /************************************************** METADATA TYPES *******************************************/
    
    public class DescribeMetadataResult {
        public SRM_MetadataAPI.DescribeMetadataObject[] metadataObjects;
        public String organizationNamespace;
        public Boolean partialSaveAllowed;
        public Boolean testRequired;
        private String[] metadataObjects_type_info = new String[]{'metadataObjects','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] organizationNamespace_type_info = new String[]{'organizationNamespace','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] partialSaveAllowed_type_info = new String[]{'partialSaveAllowed','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] testRequired_type_info = new String[]{'testRequired','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadataObjects','organizationNamespace','partialSaveAllowed','testRequired'};
    }
    
    public class DescribeMetadataObject {
        public String[] childXmlNames;
        public String directoryName;
        public Boolean inFolder;
        public Boolean metaFile;
        public String suffix;
        public String xmlName;
        private String[] childXmlNames_type_info = new String[]{'childXmlNames','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] directoryName_type_info = new String[]{'directoryName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] inFolder_type_info = new String[]{'inFolder','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] metaFile_type_info = new String[]{'metaFile','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] suffix_type_info = new String[]{'suffix','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] xmlName_type_info = new String[]{'xmlName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'childXmlNames','directoryName','inFolder','metaFile','suffix','xmlName'};
    }
    
    public class describeMetadata_element {
        public Double asOfVersion;
        private String[] asOfVersion_type_info = new String[]{'asOfVersion','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'asOfVersion'};
    }
    
    public class describeMetadataResponse_element {
        public SRM_MetadataAPI.DescribeMetadataResult result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class FileProperties {
        public String createdById;
        public String createdByName;
        public DateTime createdDate;
        public String fileName;
        public String fullName;
        public String id;
        public String lastModifiedById;
        public String lastModifiedByName;
        public DateTime lastModifiedDate;
        public String manageableState;
        public String namespacePrefix;
        public String type_x;
        private String[] createdById_type_info = new String[]{'createdById','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdByName_type_info = new String[]{'createdByName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdDate_type_info = new String[]{'createdDate','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fileName_type_info = new String[]{'fileName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedById_type_info = new String[]{'lastModifiedById','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedByName_type_info = new String[]{'lastModifiedByName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedDate_type_info = new String[]{'lastModifiedDate','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] manageableState_type_info = new String[]{'manageableState','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'createdById','createdByName','createdDate','fileName','fullName','id','lastModifiedById','lastModifiedByName','lastModifiedDate','manageableState','namespacePrefix','type_x'};
    }
    
    public class listMetadata_element {
        public SRM_MetadataAPI.ListMetadataQuery[] queries;
        public Double asOfVersion;
        private String[] queries_type_info = new String[]{'queries','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] asOfVersion_type_info = new String[]{'asOfVersion','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'queries','asOfVersion'};
    }
    
    public class ListMetadataQuery {
        public String folder;
        public String type_x;
        private String[] folder_type_info = new String[]{'folder','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'folder','type_x'};
    }
    
    public class listMetadataResponse_element {
        public SRM_MetadataAPI.FileProperties[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }

}