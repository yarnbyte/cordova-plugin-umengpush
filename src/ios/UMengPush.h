#import <Cordova/CDV.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

@interface UMengPush : CDVPlugin {
  // Member variables go here.
  NSString *_callbackId;
  NSDictionary *_pending;
}

@property (nonatomic, strong) NSString *umengPushAppId;

- (void)coolMethod:(CDVInvokedUrlCommand *)command;
- (void)setAlias:(CDVInvokedUrlCommand *)command;
- (void)addAlias:(CDVInvokedUrlCommand *)command;
- (void)deleteAlias:(CDVInvokedUrlCommand *)command;
- (void)addTags:(CDVInvokedUrlCommand *)command;
- (void)deleteTags:(CDVInvokedUrlCommand *)command;
- (void)getRemoteNotification:(CDVInvokedUrlCommand *)command;
+ (void)setPendingNotification:(NSDictionary *)notification;

@end
