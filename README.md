# cordova-plugin-umengpush

[![NPM version][npm-image]][npm-url]
[![Downloads][downloads-image]][npm-url]
[![TotalDownloads][total-downloads-image]][npm-url]

[npm-image]:http://img.shields.io/npm/v/cordova-plugin-umengpush.svg
[npm-url]:https://npmjs.org/package/cordova-plugin-umengpush
[downloads-image]:http://img.shields.io/npm/dm/cordova-plugin-umengpush.svg?label=当月下载
[total-downloads-image]:http://img.shields.io/npm/dt/cordova-plugin-umengpush.svg?label=总下载


友盟推送cordova插件，目前已支持iOS(包括iOS13)以及华为、小米、魅族、OPPO、VIVO厂家离线推送。

### 提示
该插件上传到npmjs之后，ios的framework会丢失头文件，导致编译时提示缺少头文件，解决办法是用cordova安装插件命令安装完成后，再到github下载一次源码去替换plugins里用命令安装了的`cordova-plugin-umengpush`插件。  

### 最新更新 
添加了推送参数的获取，通知参数（包含自定义参数）在用户点击通知进入APP后能通过定义好的监听获取。iOS支持冷启动获取参数，android暂时还不支持获取离线推送的参数。
#### 友盟SDK组件版本：
| 平台           |  组件                     | 版本                     |
|:------------- |:------------------------ |:----------------------- |
| `iOS`|  UMCommon.framework| v2.1.1 |
| `iOS`|  UMPush.framework| v3.2.4 |
| `Android`| com.umeng.umsdk:common| v1.5.4|
| `Android`| com.umeng.umsdk:push| v6.0.1|




## 1. 安装
需要iOS以及小米、华为、魅族、OPPO、VIVO推送的相关的AK或SK，按下面的命令安装，命令有点长，可以先用其他字符占用，再到插件里手动修改这些需要的各个信息，特别需要注意的是华为的必须一开始安装时就要输入，或者安装完成后到plugin.xml中修改，不然只能打完包后到Manifests.xml文件中修改。不可以在java代码中修改，因为java文件中没有输入的地方，如果不按这个要求将无法获取华为设备推送标识。

```
cordova plugin add cordova-plugin-umengpush --variable IOS_APPKEY=YOUR_IOS_APPKEY --variable UM_APPKEY=YOUR_UM_APPKEY --variable=UM_MESSAGE_SECRET=YOUR_UM_MESSAGE_SECRET --variable HUAWEI_APPID=YOUR_HUAWEI_APPID --variable XIAOMI_ID=YOUR_XIAOMI_ID --variable XIAOMI_KEY=YOUR_XIAOMI_KEY --variable MEIZU_APPID=YOUR_MEIZU_APPID --variable MEIZU_APPKEY=YOUR_MEIZU_APPKEY --variable OPPO_APPKEY=YOUR_OPPO_APPKEY --variable OPPO_SECRET=YOUR_OPPO_SECRET
```

安装后可到源码中修改相关AK与SK信息，位置如下：
### iOS平台
```
src/ios/UMengPush.m

默认从配置文件中获取AK，可以自己手动修改替换。

self.umengPushAppId = @"xxxxxxxxxxxx";

```

### Android平台
```
src/android/UMApplication.java

代码默认从配置文件中获取AK与SK信息，可自己手动修改替换。

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

### 插件相关接口
```
//监听通知的点击事件
var onSubscriptNotification = function (success, error) {};

//获取推送相关的设备token
var init = function (success, error) {};

var setAlias = function (alias, alias_type, success, error) {};

var addAlias = function (alias, alias_type, success, error) {};

var deleteAlias = function (alias, alias_type, success, error) {};

var addTags = function (tag, success, error) {};

var deleteTags = function (tag, success, error) {};

```

## 常见问题
#### 1.Manifest合并失败。  
可能与阿里巴巴相关的插件冲突，解决办法是把这个插件的`UTDID`库去掉，iOS去掉方法是把`plugin.xml`里的以下注释掉，   
```
<framework src="src/ios/librarys/UTDID.framework" custom="true"/>
```

Android则需要到插件的`src/android/plugin.gradle`里把以下代码注释掉，   
```
api 'com.umeng.umsdk:utdid:1.1.5.3'
```

#### 2.小米手机收到推送点击通知不能打开APP
可能是推送的时候没设置要启动的路径，官方给的HTTP API是没有设置的，需要自己加，或者可以联系我获取。


其他问题可到issues提问，提问时请尽量详细描述。

除了写代码，我平时还会进行一些电子音乐创作，创作完成后我会发布在网易云音乐，有Progressive House，Melodic Dubstep，Chillstep等风格，感兴趣的可以到网易云关注一下我啊~谢谢。音乐人：[Alamofire](https://music.163.com/#/artist?id=33349905)
