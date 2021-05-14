({
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
            var x = component.get("v.navComplete") || false;
            component.set("v.navComplete", !x);
        }
    },
    logoutCommunity : function(component, event, helper) {
        window.location.replace("/dealer/secur/logout.jsp?retUrl=dealer/%2Flogin");
    }
})