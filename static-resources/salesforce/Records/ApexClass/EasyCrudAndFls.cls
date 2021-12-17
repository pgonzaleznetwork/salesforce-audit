/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-05-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class EasyCrudAndFls {
   
    @AuraEnabled(cacheable=true)
    public static List<ObjectPermissions> getAllObjects(){
        return [Select SObjecttype from ObjectPermissions where Parent.profile.Name = 'System Administrator'];
    }


    @AuraEnabled
    public static String getFields(String objectName){
        try {
            String json_string = '[';
                for(Schema.SObjectField field : schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values()){
                    Schema.DescribeFieldResult fr = field.getDescribe();

                    if(!fr.isPermissionable())
                        continue;
                    
                    if(json_string != '['){
                        json_string += ',';
                    }
                 
                    json_string += '{"fieldApi":"'+fr.getName()+'","fieldLabel":"'+fr.getLabel()+'"}'; 
                } 
                json_string += ']';
                return json_string;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ObjectPermissions> getObjectPermissions(String objectName){
            return [Select id,ParentId,Parent.Name,Parent.Profile.Id,Parent.Profile.Name,Parent.IsOwnedByProfile,PermissionsCreate,PermissionsDelete,PermissionsRead
                    ,PermissionsEdit,PermissionsViewAllRecords,PermissionsModifyAllRecords FROM ObjectPermissions
                    where SobjectType = :objectName];
    }

    @AuraEnabled
    public static List<FieldPermissions> getFieldPermissions(String objectName,String fieldName){
        return [Select id,Field,ParentId,Parent.Profile.Id,Parent.Profile.Name,Parent.Name,Parent.IsOwnedByProfile,
                PermissionsEdit,PermissionsRead FROM FieldPermissions WHERE SobjectType = :objectName 
                AND Field = :fieldName];      
    }

    @AuraEnabled
    public static List<PermissionSet> getPermissionSets(){
            return [Select id,Profile.Id,Profile.Name,IsOwnedByProfile,Name FROM PermissionSet where NameSpacePrefix = NULL ORDER BY IsOwnedByProfile DESC];
    }


    @AuraEnabled
    public static List<String> upsertPermissions(String permissionsJson,Boolean isObject){
        try {
                    
                    List<Database.UpsertResult> results;
                    if(isObject){
                            List<ObjectPermissions> objPermissions= (List<ObjectPermissions>)System.JSON.deserialize(permissionsJson, List<ObjectPermissions>.class);
                            results = Database.upsert(objPermissions,false);
                     }else{
                            List<FieldPermissions> fls= (List<FieldPermissions>)System.JSON.deserialize(permissionsJson, List<FieldPermissions>.class);
                            results = Database.upsert(fls,false);
                     }
                    List<String> resultsOp = new List<String>();

                    for(Database.UpsertResult sr : results){
                        String json = '{"recordId":"{recordId}","isSuccess":{status},"errorMessage":"{errMsg}"}';

                            String createdRecordId = '';

                            if(sr.getId() != null){
                                createdRecordId = String.valueOf(sr.getId());
                            }

                            json = json.replace('{recordId}',createdRecordId);
                            json = json.replace('{status}',String.valueOf(sr.isSuccess()));
                        

                            String error = '';
                            for(Database.Error err : sr.getErrors()){
                              if(String.isNotBlank(error)){
                                  error+= ',';
                              }
                               error += err.getMessage();
                            }
                            json = json.replace('{errMsg}',error);

                            resultsOp.add(json);
                    }

                    return resultsOp;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }



}