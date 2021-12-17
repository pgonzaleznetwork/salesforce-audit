/*
 * Test methods for SRM_MetadataDeploymentTriggerHandler
 * Test Method Format: test[MethodName][Optional Condition]
*/
@IsTest
public class SRM_MdDeployTriggerHandlerTests {

    @IsTest
    public static void testFireNewApexCodeNotification(){


        SRM_TestData.insertTestData();

        SRM_Jira_Ticket__c deployment = [SELECT Status__c, Deployed_Apex_Names__c,Fire_New_Apex_Notification__c FROM SRM_Jira_Ticket__c LIMIT 1];

        System.assert(deployment.Deployed_Apex_Names__c == null,'There should not be any deployed apex names before the deployment status is set to Deployed');
        System.assert(!deployment.Fire_New_Apex_Notification__c,'This field should be false if the deployment status is not Deployed');

        Test.startTest();
        deployment.Status__c = 'Deployed';
        deployment.Git_Pull_Request_URL__c = 'https://github.com/websummit/sfdc/pull/new/00002039';
        deployment.Friendly_description_of_Apex_changes__c = 'some description';
        update deployment;
        Test.stopTest();

        deployment = [SELECT Status__c, Deployed_Apex_Names__c,Fire_New_Apex_Notification__c FROM SRM_Jira_Ticket__c LIMIT 1];

        String expectedValue = 'MySampleClass0,MySampleClass1,MySampleClass2,MySampleClass3';

        System.assert(deployment.Deployed_Apex_Names__c.equals(expectedValue),'This field should have the name of all the apex classes referenced in the deployment, separated by a comma');
        System.assert(deployment.Fire_New_Apex_Notification__c,'This field should be true once the deployment status is Deployed');



    }

    
}