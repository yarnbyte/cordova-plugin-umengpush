# cordova-plugin-umengpush
友盟推送cordova插件，目前已支持iOS以及华为、小米和魅族推送。

# 1. 安装
需要iOS以及小米、华为、魅族推送的相关的AK或SK，按下面的命令安装，有点长，可以先用其他字符占用。

```
cordova plugin add cordova-plugin-umengpush --variable IOS_APPKEY=YOUR_IOS_APPKEY --variable UM_APPKEY=YOUR_UM_APPKEY --variable UM_MESSAGE_SECRET=YOUR_UM_MESSAGE_SECRET --variable XIAOMI_ID=YOUR_XIAOMI_ID --variable XIAOMI_KEY=YOUR_XIAOMI_KEY --variable MEIZU_APPID=YOUR_MEIZU_APPID --variable MEIZU_APPKEY=YOUR_MEIZU_APPKEY
```

安装后可到源码中修改相关AK与SK信息，位置如下：
## iOS平台
```
src/ios/UMengPush.m

代码第19到23行，该处是从配置文件中获取AK，可以自己替换
```

## Android平台
```
src/android/UMApplication.java

代码从34到47行，是从配置文件中获取AK与SK信息，可自己替换。

代码从77到85是注册厂家通道的推送，可根据自己的需求自行修改代码。
```



# 2. 使用
## for cordova

### 初始化
根据友盟推送限制政策([https://developer.umeng.com/docs/66632/detail/68343](https://developer.umeng.com/docs/66632/detail/68343))，单播是不限制的，实现单播需要根据设备的推送token来进行推送，在插件初始化时，插件已经获取了token，可以按以下方式得到：

```
cordova.plugins.UMengPush.init(function(token){
	//得到推送token，便于直接通过token发推送信息
	console.log(token);
},function(error){
	// error
})

```

### 设置alias

```
cordova.plugins.UMengPush.setAlias("alias","ALIAS_TYPE", function (res) {
      alert(JSON.stringify(res));
    }, function (err) {
      alert(JSON.stringify(err));
    })
```



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
根据友盟推送限制政策([https://developer.umeng.com/docs/66632/detail/68343](https://developer.umeng.com/docs/66632/detail/68343))，单播是不限制的，实现单播需要根据设备的推送token来进行推送，在插件初始化时，插件已经获取了token，可以按以下方式得到：

```
upush.init().then(token => {
	//得到token
	//可根据业务将token与用户标识存储到数据库中
	console.log(token);
})

```


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


