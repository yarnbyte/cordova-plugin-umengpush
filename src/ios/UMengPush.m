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
//    这是从资源里获取的
   NSString* appId = [[self.commandDelegate settings] objectForKey:@"umengpushappid"];
   if (appId)
   {
       self.umengPushAppId = appId;
   }
   
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
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
- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    
    NSArray *args = [command arguments];
    NSString *alias = [args objectAtIndex:0];
    NSString *alias_type = [args objectAtIndex:1];
    
    NSString *t = @"====";
    if (args == nil || [args count] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[alias stringByAppendingString:t] stringByAppendingString:alias_type]];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
        if (responseObject)
        {
            [self successWithCallbackId:command.callbackId withMessage:@"设置成功"];
        }
        else
        {
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


- (void)getRemoteNotification:(CDVInvokedUrlCommand *)command
{
  _callbackId = command.callbackId;
  if (_pending) {
    [self notify:_pending];
    _pending = nil;
  }
  else {
    [self notify:@{}];
  }
}

- (void)notify:(NSDictionary *)notification
{
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:notification];
  [result setKeepCallbackAsBool:YES];
  [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
}


+ (void)setPendingNotification:(NSDictionary *)notification
{
  [static_self notify:notification];
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
