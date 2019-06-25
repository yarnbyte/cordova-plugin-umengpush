#import "AppDelegate+UmengPush.h"
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import "MainViewController.h"

@implementation AppDelegate (UmengPush)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
    //转发参数
    [self sendNotificationParms:userInfo state:@"foreground"];
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        //前台
        [self sendNotificationParms:userInfo state:@"foreground"];
    }else{
        //后台
        [self sendNotificationParms:userInfo state:@"background"];
    }
    
}
#endif
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMengPush setPendingNotification:userInfo];
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        //前台
        [self sendNotificationParms:userInfo state:@"foreground"];
    }else{
        //后台
        [self sendNotificationParms:userInfo state:@"background"];
    }
    
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.viewController = [[MainViewController alloc] init];
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:@[@"qwe",@"asd",@"zxc",@"qaz",@"wsx"] forKeys:@[@"111",@"222",@"333",@"444",@"555"]];
    
    if(userInfo){
//        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
//        [mutableDic setValue:@"launch" forKey:@"state"];
//        [mutableDic addEntriesFromDictionary:userInfo];
        //[self performSelector:@selector(postParms:) withObject:mutableDic afterDelay:3]; 怕performSelector会被拒绝，所以使用NSTimer
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [self sendNotificationParms:userInfo state:@"launch"];
            [timer invalidate];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//这是APP运行时将参数转发
- (void) sendNotificationParms: (NSDictionary *) userInfo state:(NSString *) state
{
    if(userInfo)
    {
        NSMutableDictionary *mic = [[NSMutableDictionary alloc] init];
        [mic setValue:state forKey:@"state"];
        [mic setValue:[userInfo objectForKey:@"d"] forKey:@"id"];
        [mic addEntriesFromDictionary:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appStartOptions" object:mic];
    }
}


//remote 授权
- (void)registRemoteNotification{
    
#ifdef __IPHONE_8_0
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }
    
#else
    
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
#endif
    
}
#pragma mark - remote Notification
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device token is %@",token);
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"my_deviceToken"];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送失败，原因：%@",error);
}

-(NSString*)dataToJsonString:(NSDictionary *)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
