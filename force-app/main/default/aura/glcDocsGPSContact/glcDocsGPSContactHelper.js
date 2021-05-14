({
    increaseIndex : function(component) {
        let index = component.get('v.index');
        this.setIndex(component, index+1);
    },

    decreaseIndex : function(component) {
        let index = component.get('v.index');
        this.setIndex(component, index-1);
    },

    setIndex : function(component, index) {
        component.set('v.index', index);
    },

    setCurrentAsset : function(component) {
        const index = component.get('v.index');
        const assets = this.getParamValue(component, 'assets');
        component.set('v.currentAsset', assets[index]);
    },

    saveAssetStateBeforeEdit : function(component) {
        const assets = this.getParamValue(component, 'assets');
        this.setParamValue(component, 'assetsBeforeEdit', JSON.parse(JSON.stringify(assets)));
    }
});