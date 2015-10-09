/**
 * Created by scuhmz on 10/9/15.
 */
var exec = require('cordova/exec');

module.exports = {

    share: function (message, onSuccess, onError) {
        exec(onSuccess, onError, "ShareSDK", "share", [message]);
    }

};
