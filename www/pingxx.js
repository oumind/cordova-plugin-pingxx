var cordova = require('cordova');
var exec = require('cordova/exec');
var pingxx = {};

pingxx.createPayment = function(charge, successCallback, errorCallback) {
  exec(successCallback, errorCallback, "Pingxx", "createPayment", [charge]);
};

pingxx._finishPay = function(result, errorCode, errorMsg){
   cordova.fireDocumentEvent("pingxx-pay-finished", {
        "result": result,
        "errorCode": errorCode,
        "errorMsg": errorMsg
   });
};

module.exports = pingxx;

