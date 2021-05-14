({
	onRecordLoad: function(component, event, helper) {
        if(event.getParams().changeType ==="LOADED")
        {
            let redirectRecord = component.get("v.redirectRecord");
            let componentName;
            let componentAttributes;

            if(redirectRecord.GMBLBC__Component_Name__c) //the new, preferred mechanism
            {
                componentName = redirectRecord.GMBLBC__Component_Name__c;
                if(redirectRecord.GMBLBC__Component_Attributes__c)
                    componentAttributes = JSON.parse(redirectRecord.GMBLBC__Component_Attributes__c);
                else
                    componentAttributes = {};
            }
            else if(redirectRecord.GMBLBC__Return_URL__c)  //for legacy component migration only
            {
                let parser = document.createElement('a'),
                searchObject = {},
                queries, split, i;
            
                parser.href = redirectRecord.GMBLBC__Return_URL__c;

                componentName = parser.pathname.substring(parser.pathname.search('cmp/')+4);
                
                queries = parser.search.replace(/^\?/, '').split('&');
                for( i = 0; i < queries.length; i++ ) {
                    split = queries[i].split('=');
                    searchObject[split[0]] = split[1];
                };

                componentAttributes = {
                    "pageReference":{
                        "state":searchObject
                    }
                };
            }
            else if(redirectRecord.GMBLBC__Return_Page_Reference__c)  //for ease of legacy component migration only
            {
                let pageRef = JSON.parse(redirectRecord.GMBLBC__Return_Page_Reference__c);

                componentName = pageRef.attributes.componentName;
                if(pageRef && pageRef.state)
                    componentAttributes = {
                        "pageReference":{
                            "state":pageRef.state
                        }
                    };
                else  
                    componentAttributes = {};
            }

            componentName = componentName.replace("__",":"); //i.e. convert c__myComponent ==> GMBLBC:myComponent or GMBLBC__myComponent ==> GMBLBC:myComponent
            if(!componentName.includes(":")) //i.e. convert myComponent ==> GMBLBC:myComponent
                componentName = "c:"+componentName;

            $A.createComponent(
                componentName,
                componentAttributes,
                function(newContent, status, errorMessage){
                    //Add the new content to the body array
                    let body = component.get("v.body");
                    if (status === "SUCCESS") {
                        body.push(newContent);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        body.push("INCOMPLETE:  No response from server or client is offline.");
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        body.push("ERROR: "+errorMessage);
                    }
                    component.set("v.body", body);
                }
            );
        }
	}
});