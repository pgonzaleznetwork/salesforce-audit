public with sharing class LeadTriggerHandler extends TriggerHandlerBase {
    protected override void beforeInsert(List<Sobject> newRecords) {
        List<Account> newAccounts = (List<Account>) newRecords;
    }

    protected override void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) {
       
        TopLevelClass.doSomething();

    }

}