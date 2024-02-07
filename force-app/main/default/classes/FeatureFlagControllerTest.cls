@IsTest
public with sharing class FeatureFlagControllerTest {
    @IsTest
    static void getStatsTest(){
        Feature_Flag__c flag = FeatureToggleTest.createFlag('Test',true);

        Test.startTest();
        FeatureFlagController.getFeatureStats(flag.Id);
        Test.stopTest();

    }
}