module.exports = function (context) {

    var fs = context.requireCordovaModule('fs'),
        path = context.requireCordovaModule('path');

    var platformRoot = path.join(context.opts.projectRoot, 'platforms/android/app/src/main/java/com/yl/umeng/');

    var manifestFile = path.join(platformRoot, 'UMApplication.java');

    if (fs.existsSync(manifestFile)) {

        fs.readFile(manifestFile, 'utf8', function (err, data) {
            if (err) {
                throw new Error('没有找到 UMApplication.java: ' + err);
            }

            var config_xml = path.join(context.opts.projectRoot, 'config.xml');
            var et = context.requireCordovaModule('elementtree');

            var configXml = fs.readFileSync(config_xml).toString();
            var etree = et.parse(configXml);

            var appId = etree.getroot().attrib.id;

            if (data.indexOf(appId) == -1) {

                var result = data.replace('${appid}', appId);

                fs.writeFile(manifestFile, result, 'utf8', function (err) {
                    if (err) throw new Error('替换app package name 失败' + err);
                })
            }
        });
    }


};