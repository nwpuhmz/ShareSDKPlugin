//
//  ShareSdkPlugin.m
//  ShareSDK-Cordova-Plugin
//
//  Created by scuhmz on 10/8/15.
//
//

#import "ShareSdkPlugin.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
@implementation ShareSdkPlugin
#pragma mark "API"
- (void)pluginInitialize {
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* sharesdkAppId = [[self.commandDelegate settings] objectForKey:@"sharesdkappid"];
    if(wechatAppId && wechatAppSecret && sharesdkAppId){
       
        /*Share SDK config*/
        [ShareSDK registerApp:@"aeb210256d6a"];
        
        [ShareSDK connectWeChatWithAppId:@"wxd00a1114f3a3546c"
                               appSecret:@"7730ee94ba94e0543447f81882299b37"
                               wechatCls:[WXApi class]];
        
        //连接短信分享
        [ShareSDK connectSMS];
        //连接邮件
        [ShareSDK connectMail];
        //连接打印
        [ShareSDK connectAirPrint];
        //连接拷贝
        [ShareSDK connectCopy];
        
    }
}
- (void)shareInfo:(CDVInvokedUrlCommand *)command
{
    
       NSString* title=[command.arguments objectAtIndex:0];
    NSString* content=[command.arguments objectAtIndex:1];
    NSString* url=[command.arguments objectAtIndex:2];
    NSString* imagePath=[command.arguments objectAtIndex:3];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"ipad");
        
    }
    else
    {
        NSLog(@"iphone or ipod");
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content//
                                           defaultContent:@"分享好东西"//
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:title//
                                                      url:url//
                                              description:@"分享好东西"//
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                       // [self failWithCallbackID:self.currentCallbackId withError:error];
                                    }
                                }];
    }
    
}
#pragma mark "CDVPlugin Overrides"

- (void)handleOpenURL:(NSNotification *)notification
{
    NSURL* url = [notification object];

        
        [ShareSDK handleOpenURL:url
                     wxDelegate:self];
    

}


- (void)successWithCallbackID:(NSString *)callbackID
{
    [self successWithCallbackID:callbackID withMessage:@"OK"];
}

- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID withError:(NSError *)error
{
    [self failWithCallbackID:callbackID withMessage:[error localizedDescription]];
}

- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

@end
