public without sharing class SRM_PackageXML {
    
    private final String API_VERSION;
    private final String NAMESPACE;
    
    private DOM.Document xmlDoc = new DOM.Document();
    private DOM.XmlNode xmlHead;
    
    private Map<String,Set<String>> typeToMembersMap = new Map<String,Set<String>>();
    
    public SRM_PackageXML(){
        
        SRM_Package_XML_Setting__mdt settings = [SELECT Api_Version__c, XML_Namespace__c FROM SRM_Package_XML_Setting__mdt 
                                                WHERE DeveloperName = 'Default'];
        
        API_VERSION = settings.Api_Version__c;
        NAMESPACE = settings.XML_Namespace__c;
    }
      
    public String generate(List<SRM_Metadata__c> mdItems){
        
        organizeTypesAndMembers(mdItems);
        generateMainStructure();
        
        for(String mdType : typeToMembersMap.keySet()){
            
            DOM.XMLNode types = createTypesNode(mdType);
            
            for(String memberName : typeToMembersMap.get(mdType)){
                createMembersNode(types,memberName);
            }
        }
        
        return xmlDoc.toXmlString();
        
    }
    
    private void organizeTypesAndMembers(List<SRM_Metadata__c> mdItems){
        
        for(SRM_Metadata__c mdItem : mdItems){
            
            if(typeToMembersMap.get(mdItem.Type__c) == null){
                typeToMembersMap.put(mdItem.Type__c,new Set<String>());
            }
            
            typeToMembersMap.get(mdItem.Type__c).add(mdItem.Name__c);
        }
    }
    
    private void generateMainStructure(){
        
        xmlHead = xmlDoc.createRootElement('Package',NAMESPACE,'');
        DOM.XmlNode fullName = xmlHead.addChildElement('fullName', null, null);
        fullName.addTextNode('CRMPackage');
        DOM.XmlNode version = xmlHead.addChildElement('version',null,null);
        version.addTextNode(API_VERSION);
        
    }
    
    private DOM.XMLNode createTypesNode(String typeName){
        
        DOM.XMLNode types = xmlHead.addChildElement('types',null,null);
        DOM.XMLNode memberName = types.addChildElement('name',null,null);
        memberName.addTextNode(typeName);
        return types;
        
    }
    
    private static void createMembersNode(DOM.XMLNode types,String memberName){
        DOM.XMLNode member = types.addChildElement('members', null, null);
        member.addTextNode(memberName);
        
    }
}