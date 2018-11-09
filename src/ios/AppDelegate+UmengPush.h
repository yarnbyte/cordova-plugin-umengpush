#import "AppDelegate.h"
#import "UMengPush.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (UmengPush) <UNUserNotificationCenterDelegate>
@end
