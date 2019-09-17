/********* UMengPush.m Cordova Plugin Implementation *******/

#import "UMengPush.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@implementation UMengPush

static id static_self;


#pragma mark Initialization
- (void)pluginInitialize
{
    static_self = self;
    
    //这是从资源里获取appkey
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString* appkey = [[plistDic objectForKey:@"UMengPush"] objectForKey:@"UMPUSH_APPKEY"];
    if (appkey)
    {
        self.umengPushAppId = appkey;
    }
    
	
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    //订阅用户点击通知启动APP或前台运行时收到通知的参数事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"appStartOptions" object:nil];
}


- (void)userInfoNotification:(NSNotification *)notification {
    if(notification){
        NSDictionary *dic = notification.object;
//        NSString *parms = [self dataToJsonString:dic];
//        UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"收到通知参数" message:parms delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert1 show];
        //有时候启动时间较长，导致cordova还没调用订阅方法就触发了发送从而cordvoa初始化完成后收不到启动的参数
        //就先把dic给到全局变量，订阅成功后再从全局变量获取
        _pending = dic;
        [self notify];
    }
}

-(NSString*)dataToJsonString:(NSDictionary *)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSDictionary *launchOptions = [notification userInfo];
    _pending = launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [UMConfigure initWithAppkey:self.umengPushAppId channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;

    //添加代理
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self.appDelegate;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
#endif
    //初始化注册类
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc]init];
    entity.types = UMessageAuthorizationOptionAlert | UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound;
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"可以推送");
        }else{
            NSLog(@"不可以推送，用户不允许");
        }
    }];
}


#pragma mark API
- (void)init:(CDVInvokedUrlCommand *)command
{
    
    NSString *device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"my_deviceToken"];
    if (device_token != nil) {
        [self successWithCallbackId:command.callbackId withMessage:device_token];
    }else{
        [self failWithCallbackId:command.callbackId withMessage:@"TOKEN获取失败"];
    }
}

- (void)setAlias:(CDVInvokedUrlCommand *)command
{
    NSArray *args = [command arguments];
    NSString *alias = [args objectAtIndex:0];
    NSString *alias_type = [args objectAtIndex:1];
    
    if (args == nil || [args count] == 0)
    {
        [self failWithCallbackId:command.callbackId withMessage:@"参数错误"];
        return;
    }
    
    [UMessage setAlias:alias type:alias_type response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject){
            [self successWithCallbackId:command.callbackId withMessage:@"设置成功"];
        }else{
            [self failWithCallbackId:command.callbackId withError:error];
        }
    }];
    
}


- (void)addAlias:(CDVInvokedUrlCommand *)command
{
    NSArray *args = [command arguments];
    NSString *alias = [args objectAtIndex:0];
    NSString *alias_type = [args objectAtIndex:1];
    
    if (args == nil || [args count] == 0)
    {
        [self failWithCallbackId:command.callbackId withMessage:@"参数错误"];
        return;
    }
    
    [UMessage addAlias:alias type:alias_type response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject)
        {
            [self successWithCallbackId:command.callbackId withMessage:@"添加成功"];
        }
        else
        {
            [self failWithCallbackId:command.callbackId withError:error];
        }
    }];
}


- (void)deleteAlias:(CDVInvokedUrlCommand *)command
{
    NSArray *args = [command arguments];
    NSString *alias = [args objectAtIndex:0];
    NSString *alias_type = [args objectAtIndex:1];
    
    if (args == nil || [args count] == 0)
    {
        [self failWithCallbackId:command.callbackId withMessage:@"参数错误"];
        return;
    }
    
    [UMessage removeAlias:alias type:alias_type response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject)
        {
            [self successWithCallbackId:command.callbackId withMessage:@"删除成功"];
        }
        else
        {
            [self failWithCallbackId:command.callbackId withError:error];
        }
    }];
}


- (void)addTags:(CDVInvokedUrlCommand *)command
{
    
    NSString *tag = [command.arguments objectAtIndex:0];
    
    if (tag == nil || [tag length] == 0)
    {
        [self failWithCallbackId:command.callbackId withMessage:@"参数错误"];
        return;
    }
    
    [UMessage addTags:tag response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
        if (responseObject)
        {
            [self successWithCallbackId:command.callbackId withMessage:@"添加成功"];
        }
        else
        {
            [self failWithCallbackId:command.callbackId withError:error];
        }
    }];
    
}

- (void)deleteTags:(CDVInvokedUrlCommand *)command
{
    NSString *tag = [command.arguments objectAtIndex:0];
    
    if (tag == nil || [tag length] == 0)
    {
        [self failWithCallbackId:command.callbackId withMessage:@"参数错误"];
        return;
    }

    [UMessage deleteTags:tag response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
        if (responseObject)
        {
            [self successWithCallbackId:command.callbackId withMessage:@"删除成功"];
        }
        else
        {
            [self failWithCallbackId:command.callbackId withError:error];
        }
    }];
}


- (void)subscribeNotification: (CDVInvokedUrlCommand *)command
{
    //定义一个全局的callbackId，当有通知时，将消息通过这个callbackId发送给cordvoa
    _callbackId = command.callbackId;
    [self notify];
}

- (void)notify
{ 
    //因为出现了重复发送的情况，重复的一些推送是没有我自己加的state字段的，不知道哪里来的，也没时间研究了
    //如果你知道可以告诉我一下
    if(_pending && [_pending valueForKey:@"state"]){
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:_pending];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
        _pending = nil;
    }
}


+ (void)setPendingNotification:(NSDictionary *)notification
{
  [static_self notify];
}

#pragma mark Helper Function
- (void)successWithCallbackId:(NSString *)callbackId withMessage:(NSString *)message
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)failWithCallbackId:(NSString *)callbackId withMessage:(NSString *)message
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)failWithCallbackId:(NSString *)callbackId withError:(NSError *)error
{
    [self failWithCallbackId:callbackId withMessage:[error localizedDescription]];
}
@end
