/**
* Flow apex action used in the "Generate package xml" flow. The requests variable is created by the flow itself and then passed to this class for processing. The class
* is object agnostic as it only expects a list of SRM_Metadata__c and a recordId to attach the generated package.xml to. 
 */
public  class SRM_GeneratePackageFlowAction {
    
    @AuraEnabled @InvocableVariable
    public String recordId;

    @AuraEnabled @InvocableVariable
    public String fileName;

    @AuraEnabled @InvocableVariable
    public List<SRM_Metadata__c> mdItems;

    @InvocableMethod(label='Generate package xml')
    public static void generatePackage(List<SRM_GeneratePackageFlowAction> requests){

        SRM_GeneratePackageFlowAction req = requests[0];

        String packageXML = new SRM_PackageXML().generate(req.mdItems);
        
        Attachment attachment = new Attachment();
        Blob documentBlob = Blob.valueOf(packageXML);
        attachment.Name = req.fileName;
        attachment.body = documentBlob;
        attachment.ParentId = req.recordId;
        
        insert attachment;
    }
}