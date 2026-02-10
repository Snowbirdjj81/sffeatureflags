/**
 * @description Feature flag domain class for evaluating flag state.
 */
public without sharing class FeatureFlag {
    private static Map<String, FeatureFlag> features = new Map<String, FeatureFlag>();

    @TestVisible private Feature_Flag__c record;

    private FeatureFlag(Feature_Flag__c record) {
        this.record = record;
    }

    private FeatureFlag() {
        // Intentionally blank for test-only construction.
    }

    /**
     * @description Gets a feature flag by name, caching results per transaction.
     * @param name Feature flag record name.
     * @return FeatureFlag instance.
     */
    public static FeatureFlag getFeatureFlag(String name) {
        if(features.containsKey(name) == false) {
            List<Feature_Flag__c> featureToggleRecord = [SELECT Id, Name, Active__c, activationDateTime__c, Expire_Date__c, deactivationDateTime__c,
                                                         (SELECT Id, User__c, IsActive__c FROM Flag_Overrides__r WHERE User__c = : UserInfo.getUserId())
                                                         FROM Feature_Flag__c
                                                         WHERE Name = : name
                                                         WITH USER_MODE
                                                                      LIMIT 1];
            if(featureToggleRecord.size() == 1) {
                features.put(name, new FeatureFlag(featureToggleRecord[0]));
            } else {
                features.put(name, new FeatureFlag(new Feature_Flag__c(Active__c = Test.isRunningTest())));
            }
        }
        return features.get(name);
    }

    @AuraEnabled(cacheable = true)
    /**
     * @description Convenience method to evaluate whether a feature flag is active.
     * @param name Feature flag record name.
     * @return True if active.
     */
    public static Boolean active(String name){
        return getFeatureFlag(name).isActive;
    }

    /**
     * @description Determines if the record is not null and that the Active__c
     *              field is set to true.
     */
    /**
     * @description Indicates whether the feature flag is active.
     */
    public Boolean isActive {
        get {
            // Return early if the record is null.
            if (this.record == null) {return false;}

            if (this.isOverriden) {
                return this.record.Flag_Overrides__r[0].IsActive__c;
            }

            // Determine whether the activation and deactivation time frames have been met.

            if(this.record.Active__c == false && activationDateTime != null && DateTime.now() >= activationDateTime) {
                this.record.Active__c = true;
                // update this.record;
            }
            if(this.record.Active__c == true && deactivationDateTime != null && DateTime.now() >= deactivationDateTime) {
                this.record.Active__c = false;
                // update this.record;
            }

            return this.record.Active__c == true;
        }
    }

    /**
     * @description The activationDateTime__c of the stored Feature_Flag__c record.
     */
    @TestVisible
    private Datetime activationDateTime {
        get {
            if (this.record != null) {
                return this.record.activationDateTime__c;
            }
            return null;
        }
    }

    /**
     * @description The activationDateTime__c of the stored Feature_Flag__c record.
     */
    @TestVisible
    private Datetime deactivationDateTime {
        get {
            if (this.record != null) {
                return this.record.deactivationDateTime__c;
            }
            return null;
        }
    }

    /**
     * @description The activationDateTime__c of the stored Feature_Flag__c record.
     */
    @TestVisible
    private Datetime expireDateTime {
        get {
            if (this.record != null) {return this.record.Expire_Date__c;}
            return null;
        }
    }

    @TestVisible
    private Boolean isOverriden {
        get {
            return this.record.Flag_Overrides__r.isEmpty() == false;
        }
    }

    @TestVisible
    static FeatureFlag createEmptyForTest() {
        return new FeatureFlag();
    }

    /**
     * @description Exception for expired flags.
     */
    public class ExpiredFlagException extends Exception {
        // Intentionally blank.
    }

    /**
     * @description Exception for undefined flags.
     */
    public class UndefinedFlagException extends Exception {
        // Intentionally blank.
    }
}
