@IsTest
public with sharing class FeatureFlagControllerTest {
    private static User getRunAsUser() {
        return [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    }

    @IsTest
    static void getStatsTest(){
        User runAsUser = getRunAsUser();
        System.runAs(runAsUser) {
            Feature_Flag__c flag = FeatureToggleTest.createFlag('Test', true);
            DateTime lastUsed = DateTime.now().addHours(-1);
            flag.Last_Used__c = lastUsed;
            update flag;

            Test.startTest();
            FeatureFlagController.StatWrapper stats = FeatureFlagController.getFeatureStats(flag.Id);
            Test.stopTest();

            System.assertEquals(lastUsed, stats.lastUsed, 'Expected lastUsed to match the record.');
        }
    }
}
