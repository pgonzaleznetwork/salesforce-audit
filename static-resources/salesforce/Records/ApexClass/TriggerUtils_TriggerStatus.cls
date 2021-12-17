/*
* @Author: Pablo Gonzalez
* @Date: 21th May, 2019
* 
* This class abstract the queries and fields used to determine whether a specific trigger context is enabled. Each trigger handler class is meant to
* create an instance of this class by passing the object name. The object name must correspond to a record in the Trigger_Context_Status__mdt
* Custom Metadata Type, where we can configure which trigger contexts are enabled.
*
* This is helpful in situations where a particular trigger context is causing issues in production and needs to be disabled without disabling the other
* trigger contexts.
*/
public class TriggerUtils_TriggerStatus {
    
    private Trigger_Context_Status__mdt  triggerStatus;
    
    public TriggerUtils_TriggerStatus(String objectName){
        
        
        try{
            
            triggerStatus = [SELECT Enable_Before_Insert__c,Enable_After_Insert__c,Enable_Before_Update__c,Enable_After_Update__c,
                             Enable_Before_Delete__c,Enable_After_Delete__c,Enable_After_Undelete__c
                        FROM Trigger_Context_Status__mdt  WHERE Label = :objectName LIMIT 1];
            
        } catch(System.QueryException e){
            throw new InvalidTriggerObjectException(objectName+' does not match any records of the Trigger_Context_Status__mdt Custom Metadata Type. Either fix the object name in the custom metadata, or change the name in the trigger handler.');
        }
        
        
    }

    public Boolean beforeInsertEnabled(){
        return triggerStatus.Enable_Before_Insert__c;
    } 
    
    public Boolean AfterInsertEnabled(){
        return triggerStatus.Enable_After_Insert__c;
    }
    
    public Boolean beforeUpdateEnabled(){
        return triggerStatus.Enable_Before_Update__c;
    }
    
    public Boolean afterUpdateEnabled(){
        return triggerStatus.Enable_After_Update__c;
    }
    
    public Boolean beforeDeleteEnabled(){
        return triggerStatus.Enable_Before_Delete__c;
    }
    
    public Boolean afterDeleteEnabled(){
        return triggerStatus.Enable_After_Delete__c;
    }
    
    public Boolean afterUndeleteEnabled(){
        return triggerStatus.Enable_After_Undelete__c;
    }
    
    public class InvalidTriggerObjectException extends exception{}

}