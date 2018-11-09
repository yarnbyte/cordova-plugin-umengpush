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

代码从71到79是注册厂家通道的推送，可根据自己的需求自行修改代码。
```



# 2. 使用
```
cordova.plugins.UMengPush.setAlias("alias","ALIAS_TYPE", function (res) {
      alert(JSON.stringify(res));
    }, function (err) {
      alert(JSON.stringify(err));
    })
```

## 2.1 ionic3+中使用

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

### 设置Alias

```
constructor(
  ...
  public upush: Upush,
  ...
  ){

  }

  login(){
      this.upush.setAlias(user.loginName,"ALIAS_TYPE").then(res=>{
                console.log("res==",res);
              }).catch(error=>{
                console.log("error==",error);
              })
  }

```


