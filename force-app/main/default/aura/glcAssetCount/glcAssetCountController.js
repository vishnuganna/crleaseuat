({
    onPreApprovalChange: function (component, event, helper){
        let isPreapprovalChecked = helper.getParamValue(component, 'isPreApprovalChecked');
        if(!isPreapprovalChecked){
            helper.setParamValue(component, 'PreApprovalAmount', null);
            
        }
    }, 

  
    onStatusCheck: function (cmp, event, helper) {
      var selectedStatus = cmp.find('select').get('v.value');
       cmp.set('v.Pre-approval Requested',selectedStatus);
        //console.log(selectedStatus);
        
      
    },

    onAssetCountChange : function (component, event, helper){
        let assetCount = helper.getParamValue(component, 'assetCount');
        if(assetCount <= 1){
            helper.setParamValue(component, 'isSameAssets', false);
        }
    }
});