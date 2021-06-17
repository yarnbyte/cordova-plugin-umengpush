module.exports = function (ctx) {
    'use strict';
    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path'),
        deferral = ctx.requireCordovaModule('q').defer(),
        async = require('async');
    var platformRoot = path.join(ctx.opts.projectRoot, 'platforms/android');
    var gradleFiles = [path.join(platformRoot, 'build.gradle')];
    async.each(gradleFiles, function (f, cb) {
        fs.readFile(f, 'utf8', function (err, data) {
            if (err) {
                cb(err);
                return;
            }
            var result = data.replace(/jcenter\(\)/g, 'jcenter()\r\t\tmaven { url "https://repo1.maven.org/maven2/" }');
            fs.writeFile(f, result, 'utf8', cb);
        });
    }, function (err) {
        if (err) {
            deferral.reject();
        } else {
            deferral.resolve();
        }

    });
    return deferral.promise;
}