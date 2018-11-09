module.exports = function(context) {

  var fs = context.requireCordovaModule('fs'),
    path = context.requireCordovaModule('path');

  var platformRoot = path.join(context.opts.projectRoot, 'platforms/android/app/src/main/');


  var manifestFile = path.join(platformRoot, 'AndroidManifest.xml');

  if (fs.existsSync(manifestFile)) {

    fs.readFile(manifestFile, 'utf8', function (err,data) {
      if (err) {
        throw new Error('没有找到 AndroidManifest.xml: ' + err);
      }

      var appClass = 'com.yl.umeng.UMApplication';

      if (data.indexOf(appClass) == -1) {

        var result = data.replace(/<application/g, '<application android:name="' + appClass + '"');

        fs.writeFile(manifestFile, result, 'utf8', function (err) {
          if (err) throw new Error('不能把android:name="com.yl.umeng.UMApplication"写入AndroidManifest.xml: ' + err);
        })
      }
    });
  }


};