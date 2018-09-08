var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'coolMethod', arg0);
};

exports.setAlias = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'setAlias', arg0);
};

exports.addAlias = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'addAlias', arg0);
};

exports.deleteAlias = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'deleteAlias', arg0);
};

exports.addTags = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'addTags', arg0);
};

exports.deleteTags = function (arg0, success, error) {
    exec(success, error, 'UMengPush', 'deleteTags', arg0);
};
