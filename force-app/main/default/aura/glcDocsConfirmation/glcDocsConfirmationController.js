({
    redirectToHome : function (component, event, helper){
        helper.navigateTo(component, helper.makeCommunityPageRef('Home'));
    },
    redirectToDeals : function (component, event, helper){
        helper.redirectToOpportunityKanban(component);
    }
});