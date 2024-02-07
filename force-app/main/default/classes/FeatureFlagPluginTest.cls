@IsTest
public with sharing class FeatureFlagPluginTest {
    @IsTest
    static void getFlag(){
        Feature_Flag__c flag = FeatureToggleTest.createFlag('Test',true);

        FeatureFlagPlugin.Requests req = new FeatureFlagPlugin.Requests();
        req.name = 'Test';

        Test.startTest();
        List<FeatureFlagPlugin.Results> res = FeatureFlagPlugin.checkFlags(new List<FeatureFlagPlugin.Requests> {req});
        Test.stopTest();

        System.assertEquals(1, res.size());
        System.assert (res[0].active, 'Feature was not active');
    }
}