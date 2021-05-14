({
    handleSelect: function (cmp, event, helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        var selectedMenuItemValue = event.getParam("value");
       // alert("Menu item selected with value: " + selectedMenuItemValue);
    },
    handleNavComplete: function (cmp, event, helper) {
        var navMenu = cmp.find('nav-button-menu');
        if($A.util.hasClass(navMenu, 'slds-is-open')){
        	$A.util.removeClass(navMenu, 'slds-is-open');    
        }
    }
});