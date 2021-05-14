({
    doInit: function (component, event, helper) {
        try {
            let index = component.get('v.index');
            let assets = helper.getParamValue(component, 'assets');
            let truckValuations = helper.getParamValue(component, 'truckValuations');
            component.set('v.optionsAmount', helper.calculateOptionsAmount(component));

            component.set('v.asset', assets[index]);
            component.set('v.truckValuation', truckValuations[index]);;
        } catch (e) {
            console.log(e.message)
        }
    }
});