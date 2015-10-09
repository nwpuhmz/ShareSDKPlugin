//
//  CDVShareSDK.h
//  Hello
//
//  Created by scuhmz on 10/9/15.
//
//

#import <Cordova/CDV.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
@interface CDVShareSDK : CDVPlugin
@property (nonatomic, strong) NSString *wechatAppId;
- (void)share:(CDVInvokedUrlCommand *)command;
@end
