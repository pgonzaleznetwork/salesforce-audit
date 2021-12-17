public with sharing class ContactTriggerHandlerV2 implements ITrigger{

    Set<Id> accountIds = new Set<Id>();
    Map<Id,List<Integer>> contactAgesByAccountId = new Map<Id,List<Integer>>();

    /**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	public void bulkBefore(){

    }
	
	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	public void bulkAfter(){

        switch on Trigger.operationType {

            when AFTER_INSERT {
                
                for(Contact newContact : (List<Contact>)Trigger.new){
                    if(newContact.Birthdate != null){
                        accountIds.add(newContact.AccountId);
                    }
                }

            }
   
            when AFTER_UPDATE {
                
                for(Contact newContact : (List<Contact>)Trigger.new){

                    Contact oldContact = (Contact) trigger.oldMap.get(newContact.Id);

                    if(oldContact.Birthdate != newContact.Birthdate && newContact.Birthdate != null){
                        accountIds.add(newContact.AccountId);
                    }
                }
            }
        }

        //now here it's way more explicit why we are checking if accountIds is not null; it was just modified a few lines ago
        //and we know we are in the AFTER X context
        if(!accountIds.isEmpty()){

            List<Account> accounts = [SELECT (SELECT Age__c FROM Contacts WHERE Age__c != null), Average_Age__c FROM Account WHERE Id IN :accountIds];

            for(Account acct : accounts){

                Integer totalAges = 0;

                for (Contact c : acct.Contacts) {
                    totalAges += Integer.valueOf(c.Age__c);
                }
                acct.Average_Age__c = totalAges/acct.Contacts.size();
            }

            System.debug('This is being executed only in the AFTER trigger: '+Trigger.IsAfter);
            update accounts;
        }

    }
	
	/**
	 * beforeInsert
	 *
	 * This method is called iteratively for each record to be inserted during a BEFORE
	 * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
	 */
	public void beforeInsert(SObject so){

    }
	
	/**
	 * beforeUpdate
	 *
	 * This method is called iteratively for each record to be updated during a BEFORE
	 * trigger.
	 */
	public void beforeUpdate(SObject oldSo, SObject so){

    }

	/**
	 * beforeDelete
	 *
	 * This method is called iteratively for each record to be deleted during a BEFORE
	 * trigger.
	 */
	public void beforeDelete(SObject so){

    }

	/**
	 * afterInsert
	 *
	 * This method is called iteratively for each record inserted during an AFTER
	 * trigger. Always put field validation in the 'After' methods in case another trigger
	 * has modified any values. The record is 'read only' by this point
	 */
	public void afterInsert(SObject so){

    }

	/**
	 * afterUpdate
	 *
	 * This method is called iteratively for each record updated during an AFTER
	 * trigger.
	 */
	public void afterUpdate(SObject oldSo, SObject so){

    }

	/**
	 * afterDelete
	 *
	 * This method is called iteratively for each record deleted during an AFTER
	 * trigger.
	 */
	public void afterDelete(SObject so){

    }

	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
	public void andFinally(){

        logContext();
    }

    private void logContext(){

        switch on Trigger.operationType {

            when BEFORE_INSERT{
                System.debug('finally executed on BEFORE INSERT');
            }
         
            when AFTER_INSERT {
                System.debug('finally executed on AFTER INSERT');
            }
            when BEFORE_UPDATE {
                System.debug('finally executed on BEFORE UPDATE');
            }
            when AFTER_UPDATE {
                System.debug('finally executed on AFTER UPDATE');
            }
        }
    }

}