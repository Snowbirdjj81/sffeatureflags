/**
 * @description Controller for feature flag statistics used by the UI.
 */
public with sharing class FeatureFlagController {
    /**
     * @description Returns usage statistics for a feature flag record.
     * @param recordId Feature flag record Id.
     * @return StatWrapper with last used datetime.
     */
    @AuraEnabled(cacheable = true)
    public static StatWrapper getFeatureStats(Id recordId){
        Feature_Flag__c flag = [SELECT Id, Last_Used__c
                                FROM Feature_Flag__c
                                WHERE Id = :recordId
                                WITH USER_MODE
        ];

        StatWrapper stats = new StatWrapper();
        stats.lastUsed = flag.Last_Used__c;
        return stats;
    }

    /**
     * @description Wrapper for feature flag statistics.
     */
    public class StatWrapper {
        /**
         * @description Last time the feature flag was used.
         */
        @AuraEnabled
        public DateTime lastUsed;
    }
}
