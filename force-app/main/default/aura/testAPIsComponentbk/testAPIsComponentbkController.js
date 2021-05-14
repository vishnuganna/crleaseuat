({
    ahandleSuccess : function(component, event, helper) {
        component.find('anotifLib').showToast({
            "variant": "success",
            "title": "Account Created",
            "message": "Record ID: " + event.getParam("id")
        });
       helper.setParamValue(component,'accountId', event.getParam("id"));
       helper.fetchAccount();  
    },
    chandleSuccess : function(component, event, helper) {
        component.find('cnotifLib').showToast({
            "variant": "success",
            "title": "Contact Created",
            "message": "Record ID: " + event.getParam("id")
        });
       helper.setParamValue(component,'contactId', event.getParam("id"));
      // helper.fetchContact(); 
    },
	takeExperianReport : function(component, event, helper) {
	console.log('account is' + JSON.stringify(component.get('v.account') ))	;
        console.log('contact is' + JSON.stringify((component.get('v.contact') )))	;
        helper.fetchExperianReport(component);	
	},
  
    takePaynetReport: function (component, event, helper) {
        if (helper.getParamValue(component, 'PaynetReport') == null) {
            helper.fetchPaynetReport(component);
        } else {
            component.set('v.showPaynetCompanies', false);
            $A.get('e.lightning:openFiles').fire({
                recordIds: [helper.getParamValue(component, 'PaynetReport')]
            });
        }
    },

    takePaynetCompanies: function (component, event, helper){
       // this.setParamValue(component,'contactId', '00304000008OxsRAAS');
       // this.setParamValue(component,'accountId', '0010400000BeI44AAF');
                
        if(helper.getParamValue(component, 'paynetCompanies') == null){
            helper.fetchPaynetCompanies(component);
        }else{
            component.set('v.showPaynetCompanies', true);
        }
    },
    
    takeLexisNexis: function (component, event, helper) {
       // helper.setParamValue(component,'contactId', '00304000009M2gnAAC');
       // helper.setParamValue(component,'accountId', '0010400000BeI44AAF');
        
        
        try {
            //helper.createAccount(component);
        	//helper.createContact(component);    
            helper.fetchLexisNexisInstantId(component);
                component.set('v.showLexisNexis', true);
                
            } catch (e) {
                console.log(e.message);
            }
    },
    
    close_PaynetCompanies: function (component, event, helper) {
        component.set('v.showPaynetCompanies', false);
    },

    close_ExperianReport: function (component, event, helper) {
        component.set('v.showExperianReport', false);
    }
})