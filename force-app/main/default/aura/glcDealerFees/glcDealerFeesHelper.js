({
    frequencyMapping : {
        Biweekly : {
            type: 'Payment',
            termLabel : 'payments',
            maxValue: 156,
        },
        Weekly : {
            type: 'Weekly',
            termLabel : 'weeks',
            maxValue: 312,
        },
        Monthly : {
            type: 'Monthly',
            termLabel: 'months',
            maxValue: 72,
        },
        Seasonal : {
            type: 'Payment',
            termLabel : 'payments',
            maxValue: 24,
        }
    },

    modifySlider : function(component){
        try {
            let selectedFreq = component.get('v.params.selectedPayFreq');
            let frequency = this.frequencyMapping[selectedFreq];
            let label = `Term (${frequency.type}):`;

            component.set('v.sliderLabel', label);
            component.set('v.sliderMaxVal', frequency.maxValue);
            this.setParamValue(component, 'termLabel', frequency.termLabel);
        } catch (e) {
            console.log(e.message);
        }
    },
    prepopulatePayFreq: function(component){
        if (component.get('v.params.selectedPayFreq') === undefined) {
            component.set('v.params.selectedPayFreq', 'Monthly');
        }
    },

    calculateFinanceAmount: function(component) {
        let fees = this.getLocalParamValue(component, 'dealerFees');
        let equipmentCost = this.getParamValue(component, 'equipmentCost');
        let downPayment = this.getParamValue(component, 'downPayment');
        let feesAmount = 0;

        for (let key in fees) {
            if (fees[key].selected) {
                feesAmount = feesAmount + Number(fees[key].amount);
            }
        }

        this.setParamValue(component, 'financedFees', Number(feesAmount));
        this.setParamValue(component, 'financeAmount', Number(equipmentCost) + Number(feesAmount) - Number(downPayment));
    },
});