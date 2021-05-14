({
    
    TOAST_TYPES : {ERROR : 'error', WARNING : 'warning', SUCCESS : 'success', INFO : 'info'},
    DEFAULT_ERROR_MESSAGE : 'Something went wrong. Please check logs or contact tech support.',

    callServerGeneric : function(component,event,method,callback,params) {
        var action = component.get(method);
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                // pass returned value to callback function
                console.log('call back Succeeds..with return value ' + response.getReturnValue());
                callback.call(this,response.getReturnValue());   
            } else if (state === "INCOMPLETE") {
                console.log("Incomplete State returned");
            }
                else if (state === "ERROR") 
                {
                    var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            this.showMessage(component,"Error!","Something Went Wrong.");
                            console.error("Error message: " + errors[0].message);
                        }
                    } 
                    else {
                        console.error("Unknown error");
                    }
                }  
        });
        
        $A.enqueueAction(action);
    },
    
    showMessage : function(component,title,message) {
        var toast = $A.get("e.force:showToast");
        console.log('toast raised' +  toast)	;
        // For lightning1 show the toast
        if (toast)
        {
            //fire the toast event in Salesforce1
            toast.setParams({
                "title": title,
                "message": message
            });
            toast.fire();
            alert(title + ': ' + message);
        }
        else // otherwise throw an alert
        {
            alert(title + ': ' + message);
        }
    },

    getOpptyValues : function (component,event,recordId){
        
        this.callServerGeneric(component,event,"c.getOpptyDetails",function(response){
             console.log('Stringified response is'  +response + 'stringy' + JSON.stringify(response));
             //component.set('v.oppty', response);
             let aspireData =  response;
             //if(aspireData && aspireData.length > 0){
             //this.setParams(component,"aspireData", aspireData);
             component.set('v.aspireData',aspireData);
             component.set('v.oppty',aspireData.opptys[0]);
             component.set('v.accountDetail',aspireData.Accounts[0]);
             component.set('v.contactDetail',aspireData.contacts);
             console.log('oppty is' + component.get('v.aspireData.opptys[0].Name'));
             //send to Aspire for creation
             let opptyinfo = component.get('v.oppty');
             if(!opptyinfo.AlreadyInAspire__c){
                 console.log('inserting to Aspire');
                this.sendToAspireForPush(component,event,recordId);
             }
             else {
                console.log('Updating to Aspire');
                this.sendToAspireForUpdate(component,event,recordId);    
             }
            
        },{ "opportunityId":recordId });
        
    },

    sendToAspireForPush : function (component,event,recordId){
        this.showSpinner(component);
        this.callServerGeneric(component,event,"c.sendFCAPtoAspireForCreate",function(response){
             console.log('Stringified response is'  +response + 'stringy' + JSON.stringify(response));
             console.log('Stringified Error response is'+ response.StatusRespCode);
             if(response.StatusRespCode === 200){
                 //update Opportunity
                 console.log('Stringified response2 is'  +response.Result.Result);
                 this.updateOpptyAspireStatus(component,event,recordId);
                 
             }
             else {
                //raise an error 
                console.log('Handle Error');
                this.hideSpinner(component);
                this.handleServerError(component,JSON.stringify(response));
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
             }
        },{ "opportunityId":recordId,"ContactId":component.get('v.oppty.ContactId'),"AccountId":component.get('v.oppty.AccountId') });

        
        
    },

    sendToAspireForUpdate : function (component,event,recordId){
        this.showSpinner(component);
        this.callServerGeneric(component,event,"c.sendFCAPtoAspireForUpdate",function(response){
             console.log('Stringified response is'  +response + 'stringy' + JSON.stringify(response));
             console.log('Stringified Error response is'+ response.StatusRespCode);
             if(response.StatusRespCode === 200){
                 //update Opportunity
                 console.log('Stringified response2 is'  +response.Result.Result);
                 this.updateOpptyAspireStatus(component,event,recordId);
                 
             }
             else {
                //raise an error 
                console.log('Handle Error');
                this.hideSpinner(component);
                this.handleServerError(component,JSON.stringify(response));
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
             }
        },{ "opportunityId":recordId,"ContactId":component.get('v.oppty.ContactId'),"AccountId":component.get('v.oppty.AccountId') });

        
        
    },

    updateOpptyAspireStatus : function (component,event,Id){
        console.log('id in updateOpptyAspireStatus' +Id);
        this.callServerGeneric(component,event,"c.updateOpptyStatus",function(response){
            console.log('Aspire Status updated Okay!!' + response);
            this.hideSpinner(component);
            this.showToast(component, 'Record Added and Updated ', this.TOAST_TYPES.SUCCESS);
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        },{"opportunityId":Id});
        

    },

    showToast : function (component, message, type){
        let toast = $A.get("e.force:showToast");
        toast.setParams({
            type: type,
            message: message
        });
        toast.fire();
    },

    handleServerError : function (component, originalMessage, userMessage=this.DEFAULT_ERROR_MESSAGE){
        console.error(originalMessage);
        this.showToast(component, userMessage, this.TOAST_TYPES.ERROR);
    },

    showSpinner: function (component) {
        component.set('v.isShowAbstractSpinner', true);
    },
    hideSpinner: function (component) {
        component.set('v.isShowAbstractSpinner', false);
    },
})