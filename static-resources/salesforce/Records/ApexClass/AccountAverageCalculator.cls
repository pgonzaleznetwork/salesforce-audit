public with sharing class AccountAverageCalculator {
    
    static Set<Id> accountIds = new Set<Id>();

    public static void registerDOBInsert(List<Contact> newContacts){
        for(Contact newContact :newContacts){
            if(newContact.Birthdate != null){
                accountIds.add(newContact.AccountId);
            }
        }
    }

    public static void registerDOBAfter(List<Contact> newContacts,Map<Id,Contact> oldContacts){

        for(Contact newContact : newContacts){//hello

            Contact oldContact = (Contact) oldContacts.get(newContact.Id);

            if(oldContact.Birthdate != newContact.Birthdate && newContact.Birthdate != null){
                accountIds.add(newContact.AccountId);
            }
        }
    }

    


}