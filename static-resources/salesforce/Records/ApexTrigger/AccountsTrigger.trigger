trigger AccountsTrigger on Account (after delete, after insert, after update, after undelete, before delete, before insert, before update) {
   
    if(trigger.isBefore){
        System.debug('Before trigger');
        Boolean value1 = StaticTest.staticBoolean;
        System.debug('Value1 '+value1);
        
    }
    
    if(trigger.isAfter){
        System.debug('After trigger');
        Boolean value2 = StaticTest.staticBoolean;
        System.debug('Value2 '+value2);
    }
    
    if(trigger.isBefore && trigger.isInsert){
        AccountTriggerHandler.handleBeforeInsert(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        AccountTriggerHandler.handleBeforeUpdate(trigger.oldMap,trigger.newMap);
    }
      
}