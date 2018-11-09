var exec = require('cordova/exec');

exports.coolMethod = function (alias,alias_type, success, error) {
    exec(success, error, 'UMengPush', 'coolMethod', [alias,alias_type]);
};

exports.setAlias = function (alias,alias_type, success, error) {
    exec(success, error, 'UMengPush', 'setAlias', [alias,alias_type]);
};

exports.addAlias = function (alias,alias_type, success, error) {
    exec(success, error, 'UMengPush', 'addAlias', [alias,alias_type]);
};

exports.deleteAlias = function (alias,alias_type, success, error) {
    exec(success, error, 'UMengPush', 'deleteAlias', [alias,alias_type]);
};

exports.addTags = function (tag, success, error) {
    exec(success, error, 'UMengPush', 'addTags', [tag]);
};

exports.deleteTags = function (tag, success, error) {
    exec(success, error, 'UMengPush', 'deleteTags', [tag]);
};

exports.getRemoteNotification = function(success, error){
    exec(success, error, 'UMengPush', 'getRemoteNotification', []);
}
