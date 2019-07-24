# cordova-plugin-umengpush

[![NPM version][npm-image]][npm-url]
[![Downloads][downloads-image]][npm-url]
[![TotalDownloads][total-downloads-image]][npm-url]

[npm-image]:http://img.shields.io/npm/v/cordova-plugin-umengpush.svg
[npm-url]:https://npmjs.org/package/cordova-plugin-umengpush
[downloads-image]:http://img.shields.io/npm/dm/cordova-plugin-umengpush.svg?label=月下载
[total-downloads-image]:http://img.shields.io/npm/dt/cordova-plugin-umengpush.svg?label=总下载


友盟推送cordova插件，目前已支持iOS以及华为、小米和魅族推送。
### 最新更新 
添加了推送参数的获取，通知参数（包含自定义参数）在用户点击通知进入APP后能通过定义好的监听获取。iOS支持冷启动获取参数，android暂时还不支持获取离线推送的参数。

iOS13获取DEVICE_TOKEN方式有所变化，需要在AppDelegate+UmengPush.m更改的代码为：
```
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"device token is %@",hexToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:hexToken forKey:@"my_deviceToken"];
    
}
```

## 1. 安装
需要iOS以及小米、华为、魅族推送的相关的AK或SK，按下面的命令安装，有点长，可以先用其他字符占用，再到插件里手动修改这些需要的各种ID和KEY。

```
cordova plugin add cordova-plugin-umengpush --variable IOS_APPKEY=YOUR_IOS_APPKEY --variable UM_APPKEY=YOUR_UM_APPKEY --variable UM_MESSAGE_SECRET=YOUR_UM_MESSAGE_SECRET --variable XIAOMI_ID=YOUR_XIAOMI_ID --variable XIAOMI_KEY=YOUR_XIAOMI_KEY --variable MEIZU_APPID=YOUR_MEIZU_APPID --variable MEIZU_APPKEY=YOUR_MEIZU_APPKEY
```

安装后可到源码中修改相关AK与SK信息，位置如下：
### iOS平台
```
src/ios/UMengPush.m

代码第20到24行，该处是从配置文件中获取AK，可以自己手动来替换。

self.umengPushAppId = @"xxxxxxxxxxxx";

```

### Android平台
```
src/android/UMApplication.java

代码从52到59行，是从配置文件中获取AK与SK信息，可自己手动替换。

代码从87到91是注册厂家通道的推送，可根据自己的需求自行修改代码。

代码从94到117是注册点击通知的监听。
```



# 2. 使用
## for cordova

### 初始化
根据友盟推送的发送限制政策([https://developer.umeng.com/docs/66632/detail/68343](https://developer.umeng.com/docs/66632/detail/68343))，单播是不限制的，实现单播需要根据设备的推送token来进行推送，在插件初始化时，插件已经获取了token，可以按以下方式得到：

```
UMengPush.init(function(token){
	//得到推送token，便于直接通过token发推送信息
	console.log(token);
},function(error){
	// error
})

```

### 设置alias

```
UMengPush.setAlias("alias","ALIAS_TYPE", function (res) {
      alert(JSON.stringify(res));
    }, function (err) {
      alert(JSON.stringify(err));
    })
```

### 监听用户点击通知
点击通知就会触发该方法。
```
UMengPush.onSubscriptNotification(function(data){
  //点击通知就会触发这里的代码
  alert(JSON.stringify(data));
});

```
点击通知获得的data的基本结构：

| 字段           |  说明                     |
|:------------- |:---------------------------- |
| `id`  | 该条通知的ID |
| `state`  | 该通知是前台还是后台还是启动，值有三种，foreground,background,launch，launch是只有iOS才有，iOS退出应用后，来通知时点击通知启动APP，进入APP后获取参数时state是launch，foreground就是用户正在使用过程中来了通知。 |




## for ionic3+

### 安装该插件的ionic支持

```
npm i upush
```

### 引入module.ts

```
import { Upush } from 'upush';

providers: [
  ...
  Upush,
  ...
]

```
### 初始化
根据友盟推送的发送限制政策([https://developer.umeng.com/docs/66632/detail/68343](https://developer.umeng.com/docs/66632/detail/68343))，单播是不限制的，实现单播需要根据设备的推送token来进行推送，在插件初始化时，插件已经获取了token，可以按以下方式得到：

```
upush.init().then(token => {
	//得到token
	//可根据业务将token与用户标识存储到数据库中
	console.log(token);
})

```

### 监听用户点击通知
```
upush.onSubscriptNotification().subscribe((data: any) => {
  alert(JSON.stringify(data));
});
```
点击通知获得的data的基本结构：

| 字段           |  说明                     |
|:------------- |:---------------------------- |
| `id`  | 该条通知的ID |
| `state`  | 该通知是前台还是后台还是启动，值有三种，foreground,background,launch，launch是只有iOS才有，iOS退出应用后，来通知时点击通知启动APP，进入APP后获取参数时state是launch，foreground就是用户正在使用过程中来了通知。 |

### 设置Alias

```
constructor(
  ...
  public upush: Upush,
  ...
  ){

  }

  login(){
    ...
    this.upush.setAlias(user.loginName,"ALIAS_TYPE").then(res=>{
                console.log("res==",res);
              }).catch(error=>{
                console.log("error==",error);
              })
  }

```


