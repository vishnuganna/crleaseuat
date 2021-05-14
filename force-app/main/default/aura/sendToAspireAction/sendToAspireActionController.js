({
	init : function(component, event, helper) {
		console.log('record is' + component.get('v.recordId'));
		helper.getOpptyValues(component,event,component.get('v.recordId'));
		
	},
    
    


})