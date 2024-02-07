public with sharing class FeatureFlagController {
    @AuraEnabled(cacheable = true)
    public static StatWrapper getFeatureStats(Id recordId){
        Feature_Flag__c flag = [SELECT Id, Last_Used__c
                                FROM Feature_Flag__c
                                WHERE Id = : recordId
        ];

        StatWrapper stats = new StatWrapper();
        stats.lastUsed = flag.Last_Used__c;
        return stats;
    }

    public class StatWrapper {
        @AuraEnabled
        public DateTime lastUsed;
    }
}