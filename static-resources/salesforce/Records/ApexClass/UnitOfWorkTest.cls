@IsTest
public class UnitOfWorkTest {
    

    @IsTest
    public static void challengeComplete(){

        List<Schema.SObjectType> obs = new Schema.SObjectType[] {
            Account.SObjectType,
            Contact.SObjectType,
            Note.SObjectType};

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(obs);

        for (Integer i = 0; i < 100; i++) {
            
            Account a = new Account(Name='Account'+i);
            uow.registerNew(a);

            for (Integer x = 0; x < 5; x++) {
                
                Contact c = new Contact(FirstName='Pablo',LastName='G');
                uow.registerNew(c, Contact.AccountId, a);

                Note n = new Note(Title='title',body='body');

                uow.registerNew(n, Note.ParentId, c);

            }
        }

        uow.commitWork();


        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());

    }

}