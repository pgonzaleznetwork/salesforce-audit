public with sharing class BetterClass implements ITrigger{

    Set<Id> accountIds = new Set<Id>();
    List<Account> accounts = new List<Account>();

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

        List<Contact> newContacts = (List<Contact>) trigger.new;
        Map<Id,Contact> oldContactMap = (Map<Id,Contact>) trigger.oldMap;

        switch on Trigger.operationType {

            when AFTER_INSERT {
                AccountAverageCalculator.registerDOBInsert(newContacts);
            }
   
            when AFTER_UPDATE {
                AccountAverageCalculator.registerDOBAfter(newContacts, oldContactMap);  
            }
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

        if(!accounts.isEmpty()){
            update accounts;
        }
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