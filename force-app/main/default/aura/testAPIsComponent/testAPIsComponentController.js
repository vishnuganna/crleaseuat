({
        takeExperianReport : function(component, event, helper) {
                helper.fetchExperianReport(component);	
	},
    
        takePaynetCompanies : function(component, event, helper) {
          helper.takePaynetCompaniesHelper(component);
        },
        lexisNexisController:function(component, event, helper){
           helper.lexisNexisHelper(component);
        },
        lexisNexisIndividualController:function(component, event, helper){
                helper.lexisNexisIndividualHelper(component);
        },
        handleChange: function (cmp, event) {
                var changeValue = event.getParam("value");
                switch(changeValue) {
                        case 'Experian':
                          cmp.set('v.isExperian',true);
                          cmp.set('v.isPaynet',false);
                          cmp.set('v.isLexisNexisIndividual',false);
                          cmp.set('v.isLexisCompany',false);
                          break;
                        case 'Paynet':
                          cmp.set('v.isExperian',false);
                          cmp.set('v.isPaynet',true);
                          cmp.set('v.isLexisNexisIndividual',false);
                          cmp.set('v.isLexisCompany',false);
                          break;
                        case 'Lexis Nexis Individual':
                          cmp.set('v.isExperian',false);
                          cmp.set('v.isPaynet',false);
                          cmp.set('v.isLexisNexisIndividual',true);
                          cmp.set('v.isLexisCompany',false);
                          break;
                        case 'Lexis Nexis Company':
                          cmp.set('v.isExperian',false);
                          cmp.set('v.isPaynet',false);
                          cmp.set('v.isLexisNexisIndividual',false);
                          cmp.set('v.isLexisCompany',true);
                          break;
                        default:
                          // code block
                      }
                
        }
    
})