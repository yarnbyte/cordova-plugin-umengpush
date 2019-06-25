var exec = require('cordova/exec');

exports.onSubscriptNotification = function (success, error) {
    exec(success, error, "UMengPush", "subscribeNotification", []);
};

exports.init = function (success, error) {
    exec(success, error, 'UMengPush', 'init', []);
};

exports.setAlias = function (alias, alias_type, success, error) {
    exec(success, error, 'UMengPush', 'setAlias', [alias, alias_type]);
};

exports.addAlias = function (alias, alias_type, success, error) {
    exec(success, error, 'UMengPush', 'addAlias', [alias, alias_type]);
};

exports.deleteAlias = function (alias, alias_type, success, error) {
    exec(success, error, 'UMengPush', 'deleteAlias', [alias, alias_type]);
};

exports.addTags = function (tag, success, error) {
    exec(success, error, 'UMengPush', 'addTags', [tag]);
};

exports.deleteTags = function (tag, success, error) {
    exec(success, error, 'UMengPush', 'deleteTags', [tag]);
};