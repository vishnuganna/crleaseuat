({
    doInit : function(component, event, helper) {
        helper.fetchSuperTrump(component);
        console.log('paaramas' + component.get('v.params'));
    }
});