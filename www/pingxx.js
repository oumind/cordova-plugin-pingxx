var cordova = require('cordova');
var exec = require('cordova/exec');
var pingxx = {};

pingxx.createPayment = function(charge, urlScheme) {
  exec(null, null, "Pingxx", "createPayment", [JSON.stringify(charge), urlScheme]);
};

pingxx._finishPay = function(result, errorCode, errorMsg){
   cordova.fireDocumentEvent("pingxx-pay-finished", {
        "result": result,
        "errorCode": errorCode,
        "errorMsg": errorMsg
   });
};

module.exports = pingxx;

