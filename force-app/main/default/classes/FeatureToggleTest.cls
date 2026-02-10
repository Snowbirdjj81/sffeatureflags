@isTest
global class FeatureToggleTest {
    global static Feature_Flag__c createFlag(String name, Boolean active) {
        return createFlag(name, active, null);
    }

    global static Feature_Flag__c createFlag(String name, Boolean active, DateTime expireDate) {
        Feature_Flag__c flag = new Feature_Flag__c(
            Name = name,
            Active__c = active,
            Expire_Date__c = expireDate != null ? expireDate : DateTime.now().addDays(7)
            );
        insert flag;
        return flag;
    }

    @isTest
    private static void isActive_activeTrue_expectActive() {
        createFlag('ActiveTestRecord', true);

        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('ActiveTestRecord');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assert (isActive, 'Expected the feature toggle to be active.');
    }

    @isTest
    private static void isActive_activationDateExceeded_expectActive() {
        Feature_Flag__c flag = createFlag('ActivationTestRecord', false);
        flag.ActivationDateTime__c = DateTime.newInstance(2018,03,25);
        update flag;

        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('ActivationTestRecord');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assert (isActive, 'Expected the feature toggle to be active.');
    }

    @isTest
    private static void isActive_deactivationDateExceeded_expectInactive() {
        Feature_Flag__c flag = createFlag('DeactivationTestRecord', true);
        flag.DeactivationDateTime__c = DateTime.newInstance(2006,04,15);
        update flag;

        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('DeactivationTestRecord');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assertEquals(false, isActive, 'Feature is not inactive');
    }

    @isTest
    private static void isInactive_OverrideTrue_expectActive() {
        Feature_Flag__c flag = createFlag('Override Test Record', false);

        insert new Flag_Override__c(
            Feature_Flag__c = flag.id,
            User__c = UserInfo.getUserId()
            );

        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('Override Test Record');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assert (isActive, 'Expected the feature toggle to be active.');
    }

    @isTest
    private static void isInactive_OverrideFalse_expectInactive() {
        Feature_Flag__c flag = createFlag('Override False Test Record', false);

        insert new Flag_Override__c(
            Feature_Flag__c = flag.id,
            User__c = UserInfo.getUserId(),
            IsActive__c = false
            );

        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('Override False Test Record');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assertEquals(false, isActive, 'Expected the feature toggle to be active.');
    }

    @isTest
    private static void getFeatureFlag_missingRecord_expectActiveDuringTests() {
        FeatureFlag featureToggle = FeatureFlag.getFeatureFlag('Missing Flag');

        Test.startTest();
        Boolean isActive = featureToggle.IsActive;
        Test.stopTest();

        System.assert(isActive, 'Expected missing flag to be active during tests.');
    }

    @isTest
    private static void activeMethod_existingFlag_expectActive() {
        createFlag('Active Method Test', true);

        Test.startTest();
        Boolean isActive = FeatureFlag.Active('Active Method Test');
        Test.stopTest();

        System.assert(isActive, 'Expected Active method to return true.');
    }

    @isTest
    private static void activeMethod_missingFlag_expectActiveDuringTests() {
        Test.startTest();
        Boolean isActive = FeatureFlag.Active('Missing Active Method');
        Test.stopTest();

        System.assert(isActive, 'Expected Active method to return true for missing flag during tests.');
    }

    @isTest
    private static void testVisibleGetters_nullRecord_expectNulls() {
        FeatureFlag featureToggle = FeatureFlag.createEmptyForTest();

        System.assertEquals(null, featureToggle.activationDateTime, 'Expected null activationDateTime.');
        System.assertEquals(null, featureToggle.deactivationDateTime, 'Expected null deactivationDateTime.');
        System.assertEquals(null, featureToggle.expireDateTime, 'Expected null expireDateTime.');
    }


    //This test checks records in the org and fails if any are expired.
    //This requires SeeAllData to be enabled.
    // @isTest(SeeAllData = true)
    // private static void expiredFlags_expectZero() {
    //     DateTime currentTime = System.now();
    //     List<Feature_Flag__c> flags = [SELECT Id
    //                                    FROM Feature_Flag__c
    //                                    WHERE Expire_Date__c < : currentTime];

    //     System.assertEquals(0, flags.size(),'Expired Flag Records. Please cleanup automation.');
    // }
}
