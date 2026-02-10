@IsTest
public with sharing class FeatureFlagControllerTest {
    @IsTest
    static void getStatsTest(){
        Feature_Flag__c flag = FeatureToggleTest.createFlag('Test',true);
        DateTime lastUsed = DateTime.now().addHours(-1);
        flag.Last_Used__c = lastUsed;
        update flag;

        Test.startTest();
        FeatureFlagController.StatWrapper stats = FeatureFlagController.getFeatureStats(flag.Id);
        Test.stopTest();

        System.assertEquals(lastUsed, stats.lastUsed, 'Expected lastUsed to match the record.');
    }
}
