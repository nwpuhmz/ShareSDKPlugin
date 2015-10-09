//
//  ShareSdkPlugin.m
//  ShareSDK-Cordova-Plugin
//
//  Created by scuhmz on 10/8/15.
//
//

#import "CDVShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
@implementation CDVShareSDK
#pragma mark "API"
- (void)pluginInitialize {
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* sharesdkAppId = [[self.commandDelegate settings] objectForKey:@"sharesdkappid"];
    if(wechatAppId && wechatAppSecret && sharesdkAppId){
       
        /*Share SDK config*/
        [ShareSDK registerApp:sharesdkAppId];
        
        [ShareSDK connectWeChatWithAppId:wechatAppId
                               appSecret:wechatAppSecret
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
- (void)share:(CDVInvokedUrlCommand *)command
{
     CDVPluginResult* __block pluginResult = nil;
        NSMutableDictionary *args = [command.arguments objectAtIndex:0];
            NSString *title = [args objectForKey:@"title"];
            NSString *content = [args objectForKey:@"content"];
            NSString *url = [args objectForKey:@"url"];
            NSString *imagePath = [args objectForKey:@"imagePath"];
            NSString *imageNamed = [args objectForKey:@"imageNamed"];
            NSString *description = [args objectForKey:@"description"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"ipad");
        
    }
    else
    {
        NSLog(@"iphone or ipod");
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content//
                                           defaultContent:@"瓜大市场"//
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:title//
                                                      url:url//
                                              description:description//
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
                                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"分享成功"];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                                    }
                                     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
