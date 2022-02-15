public with sharing class SaltoUIController {
    

    @AuraEnabled
    public static string sayHi(){
        try {
            return 'Hi Salto';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}