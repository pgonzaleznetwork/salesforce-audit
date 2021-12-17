public virtual with sharing class TriggerHandlerBase {

    public void run() {
        // dispatch to the correct handler method
        if(Trigger.isBefore) {
            if (Trigger.isInsert) {
                this.beforeInsert(Trigger.New);
            }
            else if(Trigger.isUpdate) {
                this.beforeUpdate(Trigger.oldMap, Trigger.newMap);
            }
            else if(Trigger.isDelete) {
                this.beforeDelete(Trigger.oldMap);
            }
        }
        // Is After
        else {
            if(Trigger.isInsert) {
                this.afterInsert(Trigger.New);
            }
            else if(Trigger.isUpdate) {
                this.afterUpdate(Trigger.oldMap, Trigger.newMap);
            }
            else if(Trigger.isDelete) {
                this.afterDelete(Trigger.oldMap);
            }
            else if(Trigger.isUndelete) {
                this.afterUndelete(Trigger.New);
            }
        }
    }

    protected virtual void beforeInsert(List<Sobject> newRecords) { }

    protected virtual void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    protected virtual void beforeDelete(Map<Id, Sobject> deletedRecordsMap) { }

    protected virtual void afterInsert(List<Sobject> newRecords) { }

    protected virtual void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    protected virtual void afterDelete(Map<Id, Sobject> deletedRecordsMap) { }

    protected virtual void afterUndelete(List<Sobject> undeletedRecords) { }
}