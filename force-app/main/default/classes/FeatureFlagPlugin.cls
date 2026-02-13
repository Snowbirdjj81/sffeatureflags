/**
 * @description Invocable entry point for checking feature flag status in flows.
 */
global with sharing class FeatureFlagPlugin {
    /**
     * @description Checks whether each requested feature flag is active.
     * @param featureRequest List of feature flag requests.
     * @return List of results indicating active status per request.
     */
    @InvocableMethod(label = 'Feature Flag' description = 'Check if a feature flag is active.' category = 'Flags')
    global static List<Results> checkFlags(List<Requests> featureRequest){
        List<Results> resultList = new List<Results>();
        for (Requests req : featureRequest) {
            resultList.add(new Results(FeatureFlag.getFeatureFlag(req.name).isActive));
        }
        return resultList;
    }

    /**
     * @description Request wrapper for a feature flag name.
     */
    global class Requests {
        /**
         * @description Record name of the feature flag to check.
         */
        @InvocableVariable(label = 'Flag Name' description = 'Record Name of the feature to check.' required = true)
        public String name;
    }

    /**
     * @description Result wrapper indicating feature flag status.
     */
    global class Results {
        /**
         * @description Whether the feature flag is active.
         */
        @InvocableVariable(label = 'Is Active' required = true)
        public Boolean active;

        /**
         * @description Creates a results wrapper.
         * @param active Whether the feature flag is active.
         */
        public Results(Boolean active){
            this.active = active;
        }
    }
}
