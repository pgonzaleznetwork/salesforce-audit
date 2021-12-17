@IsTest
public class SRM_PackageXML_Tests {
    
    @TestSetup
    private static void createRecords(){  
        SRM_TestData.insertTestData();   
    }
    
    @IsTest
    public static void testGenerate(){
        
        List<SRM_Metadata__c> mdItems = [SELECT Name__c,Type__c FROM SRM_Metadata__c];
        
        SRM_PackageXML pxml = new SRM_PackageXML();
        
        Test.startTest();
        String xmlAsString = pxml.generate(mdItems);
        Test.stopTest();
        
        Dom.Document xmlDoc = new Dom.Document();
        xmlDoc.load(xmlAsString);
        
        DOM.XmlNode xmlHead = xmlDoc.getRootElement();
        DOM.XmlNode typesElement = xmlHead.getChildElement('types','http://soap.sforce.com/2006/04/metadata');
        DOM.XmlNode typeNameNode = typesElement.getChildElement('name','http://soap.sforce.com/2006/04/metadata');
        DOM.XmlNode membersNode = typesElement.getChildElement('members','http://soap.sforce.com/2006/04/metadata');
        
        System.assert(xmlHead.getName().equals('Package'));    
        System.assert(typesElement.getName().equals('types'));      
        System.assert(typeNameNode.getText().equals('ApexClass'));
        System.assert(membersNode.getText().startsWith('MySampleClass'));   
    }   
}