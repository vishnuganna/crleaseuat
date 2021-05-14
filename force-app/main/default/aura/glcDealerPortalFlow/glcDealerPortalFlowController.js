({
    doInit : function (component, event, helper) {
        let redirectId = helper.getUrlParameter('redirectId');
        let applicationId = helper.getUrlParameter('applicationId');
        let recordId = component.get('v.recordId');

        // if ((redirectId !== undefined && performance.navigation.type !== PerformanceNavigation.TYPE_RELOAD)) {
        //     if (window.sessionStorage && window.sessionStorage.getItem('firstLoad') !== 'true') {
        //         window.sessionStorage.setItem('firstLoad', 'true');
        //         window.location.reload();
        //     }
        // }

        if (redirectId !== undefined && applicationId == null) {
            // console.log(redirectId);
            helper.setParamValue(component, 'redirectId', redirectId);

            helper.fetchAttributes(component, redirectId, PerformanceNavigation.type === PerformanceNavigation.TYPE_RELOAD, true);
        } else if ((applicationId !== undefined || recordId !== undefined)) {
            // console.log(applicationId);
            // console.log(recordId);

            if (applicationId === undefined) {
                helper.setParamValue(component, 'applicationId', recordId);
                // helper.fetchAttributes(component, recordId, PerformanceNavigation.type === PerformanceNavigation.TYPE_RELOAD, false);
                helper.fetchAttributes(component, recordId, false, false);
            } else {
                helper.setParamValue(component, 'applicationId', applicationId);
                helper.fetchAttributes(component, applicationId, PerformanceNavigation.type === PerformanceNavigation.TYPE_RELOAD, true);
                // if (window.sessionStorage && window.sessionStorage.getItem('firstLoad') !== 'true') {
                //     window.sessionStorage.setItem('firstLoad', 'true');
                //     window.location.reload();
                // }
            }
        } else if (helper.getParamValue(component, 'stage') === '') {
            // window.sessionStorage.clear();
            helper.setParamValue(component, 'stage', 'consent');
            helper.setParamValue(component, 'showProgressBar', 'false');
        }
    },

    onNext: function (component, event, helper) {
        let stage = helper.getParamValue(component, 'stage');
        // var isPhysicallyPresent = helper.getParamValue(component, 'isPhysicallyPresent');
        // switch (stage) {
        //     case 'start' :
        //         if (isPhysicallyPresent == 'true') {
        //             helper.setParamValue(component, 'stage', 'legalInfo');
        //             helper.saveToSessionStorage(component);
        //             // helper.changeStage(component, 0);
        //         } else {
        //             if (helper.getParamValue(component, 'consentMethod') == 'Phone') {
        //                 if (helper.getParamValue(component, 'phone') == '') {
        //                     helper.showMessage(component, 'Phone number can not be empty');
        //                     console.log('Phone number can not be empty');
        //
        //                     return;
        //                 }
        //                 helper.sendSms(component);
        //             } else {
        //                 if (helper.getParamValue(component, 'mail') == '') {
        //                     helper.showMessage(component, 'Email address can not be empty');
        //                     console.log('Email address can not be empty');
        //
        //                     return;
        //                 }
        //                 helper.sendEmail(component);
        //             }
        //             helper.setParamValue(component, 'stage', 'applicantInfo');
        //             helper.setParamValue(component, 'showProgressBar', 'true');
        //             helper.changeStage(component, 0);
        //         }
        //         break;
        //
        //     case 'legalInfo':
        //         helper.setParamValue(component, 'stage', 'consent');
        //         helper.saveToSessionStorage(component);
        //         // helper.changeStage(component, 0);
        //         break;
        //
        //     case 'consent' :
        //         if (isPhysicallyPresent == 'true') {
        //             if(helper.getParamValue(component, 'agreeTerms')) {
                        helper.setParamValue(component, 'stage', 'applicantInfo');
                        helper.setParamValue(component, 'showProgressBar', 'true');
                        helper.setParamValue(component, 'agreeTerms', 'true');
                        helper.changeStage(component, 0, false);
                    // }
        //         }
        //         break;
        // }
    }
});