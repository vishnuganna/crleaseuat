({
    MAIN_STAGE : 'docsChecklist',

    CHECKLIST_STAGES : [
        { apiName: 'cdl', name: 'CDL', completed : false },
        { apiName: 'dealerInvoice', name: 'Dealer Invoice (Final)', completed : false },
        { apiName: 'dealerSheet', name: 'Dealer Spec Sheet', completed : false },
        { apiName: 'titleRegistration', name: 'Title & Registration', completed : false },
        { apiName: 'guaranteeOfTitle', name: 'Guarantee of Title', completed : false },
        { apiName: 'gpsContactLocation', name: 'GPS Contact & Install Location', completed : false},
        { apiName: 'proofOfInsurance', name: 'Proof of Insurance', completed : false},
    ],

    DOCS_SHOW_CANCEL_MAP : {
        docsChecklist : true,
        cdl: true,
        dealerInvoice: true,
        dealerSheet : true,
        titleRegistration: true,
        assetTitle : true,
        guaranteeOfTitle : true,
        gpsContactLocation : true,
        proofOfInsurance: true,
    },

    DOCS_SHOW_SAVE_MAP : {
        cdl: true,
        dealerInvoice: true,
        dealerSheet: true,
        assetTitle : true,
        guaranteeOfTitle : true,
        proofOfInsurance: true,
    },

    DOCS_SHOW_CONTINUE_BUTTON : {
        docsChecklist: true,
        docsNotes: true,
        titleRegistration: true,
    },

    initParams : function (component){
        Promise.all([this.loadOpportunity(component), this.loadAssets(component)])
            .then( _ => this.moveToMainStage(component))
            .catch( e => this.handleServerError(component, e))
    },

    loadOpportunity : function (component){
        let params = { "oppId": component.get('v.recordId') };
        return this.serverCall(component, "c.getOpportunityById", params)
            .then( opportunity => {
                if(opportunity.Data_Map__c){
                    this.parseStagesState(component, opportunity.Data_Map__c);
                }else{
                    this.initBasicStagesState(component,opportunity);
                }
                this.initOpportunity(component, opportunity);
            })
    },

    loadAssets : function (component){
        let params = { "oppId": component.get('v.recordId') };
        return this.serverCall(component, "c.getAssetsRelatedToOpportunity", params)
            .then( assets => this.setParamValue(component, 'assets', assets))
    },

    initOpportunity : function(component, opportunity){
        delete opportunity.Data_Map__c;
        this.setParamValue(component, 'opportunity', opportunity);
    },

    initBasicStagesState : function (component){
        this.setParamValue(component, 'stages', this.CHECKLIST_STAGES);
    },

    parseStagesState : function (component, stagesMap) {
        let responseString = JSON.parse(stagesMap
            .replaceAll('&quot;', '"')
            .replaceAll('&amp;', '&')
        );
        component.set('v.params.stages', responseString);
    },

    continue : function (component){
        const strategies = {
            'docsChecklist' :       {nextStage: 'docsNotes'},
            'docsNotes' :           {nextStage: 'docsConfirmation', command: this.submitDocsRequest},
            'titleRegistration' :   {nextStage: 'assetTitle'},
        }
        const currentStage = this.getCurrentStage(component);
        this.continueStrategyHandler(component, strategies[currentStage]);
    },

    save : function (component){
        const currentStage = this.getCurrentStage(component);
        const strategies = {
            'assetTitle' :          {command: this.saveAssetTitleAction},
            'guaranteeOfTitle' :    {command: this.saveGuarantee},
            'gpsContactLocation' :  {command: this.saveGpsStageAction},
            'DEFAULT_STRATEGY' :    {command: this.moveToMainStage}
        }

        const {command} = strategies[currentStage] ? strategies[currentStage] : strategies['DEFAULT_STRATEGY'];
        command.call(this, component);
    },

    cancel : function (component) {
        const currentStage = this.getCurrentStage(component);
        const strategies = {
            'docsChecklist' :       {command: this.redirectToOpportunityKanban},
            'gpsContactLocation' :  {command: this.cancelGpsStageAction},
            'DEFAULT_STRATEGY' :    {command: this.moveToMainStage}
        }

        const {command} = strategies[currentStage] ? strategies[currentStage] : strategies['DEFAULT_STRATEGY'];
        command.call(this, component);
    },

    continueStrategyHandler : function(component, strategy){
        const {command, nextStage} = strategy;
        if(command && command instanceof Function){
            command.call(this, component)
                .then( _ => this.moveToStage(component, nextStage))
                .catch( e => this.handleServerError(component, e))
        } else{
            this.moveToStage(component, nextStage);
        }
    },

    submitDocsRequest : function (component){
        let params = {
            "opp": this.getParamValue(component, 'opportunity'),
        };
        return this.serverCall(component, "c.submitDocsRequest", params)
            .catch( e => this.handleServerError(component, e));
    },

    saveGuarantee : function (component){
        let isSkipSave = this.getParamValue(component, 'isNotRequired');
        if(!isSkipSave){
            this.updateOpportunity(component)
                .then( _ =>  {
                    this.completeCurrentStage(component);
                    this.moveToMainStage(component);
                })
                .catch( e => this.handleServerError(component, e))
        }else{
            this.completeCurrentStage(component);
            this.moveToMainStage(component);
        }
    },

    saveAssetTitleAction : function (component){
        this.fillTitlePageData(component);
        this.updateAssets(component)
            .then( _ =>{
                this.completeStage(component, 'titleRegistration');
                this.moveToMainStage(component);
            })
            .catch( e => this.handleServerError(component, e))
    },

    saveGpsStageAction : function(component){
        let isSkipSave = this.getParamValue(component, 'isGPSAlreadyCompleted');
        let isApplyForAll = this.getParamValue(component, 'isGPSApplyForAllAssets');
        if(!isSkipSave){
            if(isApplyForAll){
                this.fillGpsData(component);
            }
            this.updateAssets(component)
                .then( _ =>{
                    this.completeCurrentStage(component);
                    this.moveToMainStage(component);
                })
                .catch( e => this.handleServerError(component, e))
        }else{
            this.completeCurrentStage(component);
            this.moveToMainStage(component);
        }
    },

    cancelGpsStageAction : function(component){
        this.restoreAssetsState(component);
        this.moveToMainStage(component);
    },

    //All asset should have same value from Title&Registration page
    fillTitlePageData: function (component){
        let {isProcessingTitle, isProcessingRegistration, isIRP, vinVerification} = this.getParamValue(component, 'titlePage');
        const assets = this.getParamValue(component, 'assets')
            .map(asset => {
                asset.CrossroadsTitle__c =  isProcessingTitle;
                asset.CrossroadsReg__c = isProcessingRegistration;
                asset.IRP__c = isIRP;
                asset.VIN_Verification_Number__c = vinVerification;
                return asset;
            })
        this.setParamValue(component, 'assets', assets);
    },

    //Populate 1 asset values to other from Gps page
    fillGpsData: function (component){
        const assets = this.getParamValue(component, 'assets')
            .map( (asset, index, assetsArray)  => {
                asset.GPS_Contact_Phone_Number__c =  assetsArray[0].GPS_Contact_Phone_Number__c;
                asset.GPS_Contact__c = assetsArray[0].GPS_Contact__c;
                asset.GPS_Install_Location__c = assetsArray[0].GPS_Contact__c;
                asset.GPS_Serial_Number__c = assetsArray[0].GPS_Serial_Number__c;
                return asset;
            })
        this.setParamValue(component, 'assets', assets);
    },

    restoreAssetsState : function (component) {
        const assetsBeforeEdit = this.getParamValue(component, 'assetsBeforeEdit');
        this.setParamValue(component, 'assets', JSON.parse(JSON.stringify(assetsBeforeEdit)));
    },

    updateOpportunity: function (component){
        let params = {
            "opp": this.getParamValue(component, 'opportunity'),
        };
        return this.serverCall(component, "c.updateOpportunity", params);
    },

    updateAssets: function (component){
        let params = {
            "assets": this.getParamValue(component, 'assets'),
        };
        return this.serverCall(component, "c.updateAssets", params)
    },

    moveToMainStage : function (component){
        this.moveToStage(component, this.MAIN_STAGE);
    },

    moveToStage : function(component, stageName) {
        this.setParamValue(component, 'stage', stageName);
        this.setButtonView(component, stageName);
    },

    setButtonView : function (component, stageName) {
        this.setParamValue(component, 'isShowCancel', this.DOCS_SHOW_CANCEL_MAP[stageName]);
        this.setParamValue(component, 'isShowContinue', this.DOCS_SHOW_CONTINUE_BUTTON[stageName]);
        this.setParamValue(component, 'isShowSave', this.DOCS_SHOW_SAVE_MAP[stageName]);
    },

    completeCurrentStage : function (component){
        const currentStage = this.getCurrentStage(component);
        this.completeStage(component, currentStage);
    },

    completeStage : function (component, stage){
        this.markStageAsCompleted(component, stage);
        this.saveStageStateToDataMap(component)
            .then( _ => this.showToast(component, 'The stage has been completed', this.TOAST_TYPES.SUCCESS))
            .catch( e => this.handleServerError(component, e))
    },

    markStageAsCompleted : function(component, stageToComplete){
        let stages = this.getParamValue(component, 'stages')
            .map((stage) => {
                if(stage.apiName == stageToComplete){
                    stage.completed = true;
                }
                return stage;
            })
        this.setParamValue(component, 'stages', stages);
    },

    saveStageStateToDataMap : function (component){
        const dataMap = JSON.stringify(component.get('v.params.stages'));
        let params = {
            "recordId": component.get('v.recordId'),
            "dataMap": dataMap
        };
        return this.serverCall(component, "c.saveParamsToDataMap", params)
    },

    getCurrentStage : function(component){
        return this.getParamValue(component, 'stage');
    },
});