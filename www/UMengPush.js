var exec = require('cordova/exec');

exports.coolMethod = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'coolMethod', arg);
};

exports.setAlias = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'setAlias', arg);
};

exports.addAlias = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'addAlias', arg);
};

exports.deleteAlias = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'deleteAlias', arg);
};

exports.addTags = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'addTags', arg);
};

exports.deleteTags = function (arg, success, error) {
    exec(success, error, 'UMengPush', 'deleteTags', arg);
};

exports.getRemoteNotification = function(success, error){
    exec(success, error, 'UmengPush', 'getRemoteNotification', []);
}
