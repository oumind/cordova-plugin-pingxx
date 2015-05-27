module.exports = {
  createPayment: function(name, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "Pingxx", "createPayment", [name]);
  }
};
