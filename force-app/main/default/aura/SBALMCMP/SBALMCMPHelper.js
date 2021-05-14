({
    fetchSBALMRecords:function(component){
        component.set("v.isLoading", true);
        var action = component.get("c.getSBALMList");
        action.setParams({
            "oppID":component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var resultData = response.getReturnValue();  
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.data", resultData);
                
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error: "+message);
                component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action); 
        
    }
})