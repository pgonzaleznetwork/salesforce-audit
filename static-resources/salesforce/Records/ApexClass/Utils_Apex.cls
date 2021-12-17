/*
* Resuable utilities/patterns that have emerged throughout the years developing for Web Summit.  
*/
public class Utils_Apex {
    
    /*
    * Creates a map of lists of strings by id. i.e to keep track of all the additional emails of a contact (as a set)
    * by their Id. The Id however, can be any Id field, not just the record Id. Check references to this method to see
    * how it is used. 
    */
    public static Map<Id,Set<String>> mapStringsById(String key,String value, List<sObject> records){

        Map<Id,Set<String>> stringsById = new Map<Id,Set<String>>();

        for (sObject record : records) {

            Id keyField = (Id)record.get(key);
           
            if (stringsById.get(keyField) == null) {
                stringsById.put(keyField,new Set<String>());
            }

           stringsById.get(keyField).add((String)record.get(value));
        }
        return stringsById;
    }

    /*
    * Same as above. The reason this is a separate method is because the client code might be expecting a set of ids.
    * If we were to use the previous method, an error would occur because an instance of Set<Id> is never an instance of Set<String>
    */
    public static Map<Id,Set<Id>> mapIdsById(String key,String value, List<sObject> records){

        Map<Id,Set<Id>> idsById = new Map<Id,Set<Id>>();

        for (sObject record : records) {

            Id keyField = (Id)record.get(key);
           
            if (idsById.get(keyField) == null) {
                idsById.put(keyField,new Set<Id>());
            }

           idsById.get(keyField).add((Id)record.get(value));
        }
        return idsById;
    }

    /*
    * To be used when creating a list of sObjects by a particular id. This id could be a relationship field, or an external
    * id, etc. It doesn't have to be the record id. Check references to this method to see how it is used. 
    */
    public static Map<Id,List<sObject>> mapRecordsByCustomId(String key,List<sObject> records){

        String relationshipField;
        Boolean keyIsRelationshipField = key.contains('.');
  
        if(keyIsRelationshipField){
            relationshipField = key.substringBefore('.');
            key = key.substringAfter('.');
        }

        Map<Id,List<sObject>> recordsById = new Map<Id,List<sObject>>();

        for (sObject record : records) {
     
            Id keyField;
            
            if (keyIsRelationshipField) {
                SObject sObj = record.getSObject(relationshipField);
                keyField = (Id)sObj.get(key);
            }
            else{
                keyField = (Id)record.get(key);
            }
             
            if (recordsById.get(keyField) == null) {
                recordsById.put(keyField,new List<sObject>());
            }

           recordsById.get(keyField).add(record);
        }
        return recordsById;
    }

}