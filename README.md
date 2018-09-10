# cordova-plugin-umengpush
友盟推送cordova插件

## 1. 安装
```
cordova plugin add cordova-plugin-umengpush --variable UM_APPKEY=YOUR_UM_APPKEY --variable UM_MESSAGE_SECRET=YOUR_UM_MESSAGE_SECRET
```

## 2. 使用
```
cordova.plugins.UMengPush.coolMethod("测试数据", function (res) {
      alert(JSON.stringify(res));
    }, function (err) {
      alert(JSON.stringify(err));
    })
```

### 2.1 ionic3+使用(beta)(还没来得及测试)
```
npm i ionic-umengpush --save
```

### 2.2 添加到```app.moudles.ts```的```providers[]```中。
```
providers: [
    ...
    UMengPush,
    ...
  ]
```

### 2.3 尽情使用吧
```
constructor(public navCtrl: NavController,
    public umengpush: UMengPush) {
      init()
  }
  
  init(){
    this.umengpush.setAlias("xxx").then(result => {
      alert(JSON.stringify(result))
      console.log("================")
      console.log(JSON.stringify(result));
    }).catch(err=>{
      alert(JSON.stringify(err));
    });
  }
  ```
