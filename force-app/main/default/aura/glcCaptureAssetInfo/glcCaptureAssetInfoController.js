({
    onNext: function(component, event, helper) {
        let stageName = helper.getParamValue(component, 'stageName');

        if (stageName === 'options2' || stageName === 'review') {
            helper.saveAsset(component, true);
        }else if(stageName === 'assetCount'){
            let totalAssets = helper.getParamValue(component, 'assetCount')
            if(!totalAssets || totalAssets === '0'){
                helper.jumpToDealStructure(component);
            }else{
                helper.changeStage(component, 1);
            }
        } else if (stageName === 'documentsPhotos') {
            helper.createOpportunityAssets(component);
            if (helper.getParamValue(component, 'assets').length < helper.getParamValue(component, 'assetCount')) {
                helper.addAssetHelper(component, -4);
            } else {
                helper.changeStage(component, 1);
            }
        } else {
            helper.changeStage(component, 1);
        }
    }
});