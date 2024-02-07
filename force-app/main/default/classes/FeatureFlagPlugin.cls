global with sharing class FeatureFlagPlugin {
    @InvocableMethod(label = 'Feature Flag' description = 'Check if a feature flag is active.' category = 'Flags')
    global static List<Results> checkFlags(List<Requests> featureRequest){
        List<Results> resultList = new List<Results>();
        for (Requests req : featureRequest) {
            resultList.add(new Results(FeatureFlag.getFeatureFlag(req.name).IsActive));
        }
        return resultList;
    }

    global class Requests {
        @InvocableVariable(label = 'Flag Name' description = 'Record Name of the feature to check.' required = true)
        global String name;
    }

    global class Results {
        @InvocableVariable(label = 'Is Active' required = true)
        global Boolean active;

        global Results(Boolean active){
            this.active = active;
        }
    }
}