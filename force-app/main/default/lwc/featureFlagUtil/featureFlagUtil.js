import checkFlagApex from '@salesforce/apex/FeatureFlag.Active'

export async function checkFlag(flagName) {
    return new Promise((resolve, reject) => {
        checkFlagApex({ name: flagName })
            .then(resolve)
            .catch(reject)
    })
}