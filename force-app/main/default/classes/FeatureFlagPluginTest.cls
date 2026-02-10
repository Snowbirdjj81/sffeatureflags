@IsTest
public with sharing class FeatureFlagPluginTest {
    private static User getRunAsUser() {
        return [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    }

    @IsTest
    static void getFlag(){
        User runAsUser = getRunAsUser();
        System.runAs(runAsUser) {
            Feature_Flag__c flag = FeatureToggleTest.createFlag('Test', true);

            FeatureFlagPlugin.Requests req = new FeatureFlagPlugin.Requests();
            req.name = 'Test';

            Test.startTest();
            List<FeatureFlagPlugin.Results> res = FeatureFlagPlugin.checkFlags(new List<FeatureFlagPlugin.Requests> {req});
            Test.stopTest();

            System.assertEquals(1, res.size());
            System.assert(res[0].active, 'Feature was not active');
        }
    }

    @IsTest
    static void getFlagMissingRecordExpectActiveDuringTests(){
        User runAsUser = getRunAsUser();
        System.runAs(runAsUser) {
            FeatureFlagPlugin.Requests req = new FeatureFlagPlugin.Requests();
            req.name = 'Missing Flag';

            Test.startTest();
            List<FeatureFlagPlugin.Results> res = FeatureFlagPlugin.checkFlags(new List<FeatureFlagPlugin.Requests> {req});
            Test.stopTest();

            System.assertEquals(1, res.size());
            System.assert(res[0].active, 'Expected missing flag to be active during tests.');
        }
    }
}
