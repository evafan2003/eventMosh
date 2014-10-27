//
//  ShareMethod.m
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ShareMethod.h"
#import "GlobalConfig.h"

@implementation ShareMethod

+ (void) shareWithContent:(FrontiaShareContent *)content
{
    FrontiaShare *share = [Frontia getShare];
    
    //微信的appid,新浪等其他的不用填
    [share registerWeixinAppId:APPID_WEIXIN];
    
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
        [GlobalConfig showAlertViewWithMessage:@"授权失败，请重新授权" superView:nil];
    };
    
    //分享结果回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
        if (respones) {
            [GlobalConfig showAlertViewWithMessage:@"分享成功" superView:nil];
        }
        else {
            [GlobalConfig showAlertViewWithMessage:@"发送成功" superView:nil];
        }
//        if (!respones) {
//            [GlobalConfig showAlertViewWithMessage:@"发送成功" superView:nil];
////        }
//        NSArray *fail = [GlobalConfig convertToArray:respones[@"fail"]];
//        NSArray *success = [GlobalConfig convertToArray:respones[@"success"]];
//        if (success.count > 0) {
//            NSString *platform = success[0];
//            [ShareMethod showResultWithPlatform:platform success:YES content:content];
//        }
//        if (fail.count > 0) {
//            NSString *platform = success[0];
//            [ShareMethod showResultWithPlatform:platform success:NO content:content];
//        }
//
       
    };
    
    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,
                           FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,
                           FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
                           FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,
                           FRONTIA_SOCIAL_SHARE_PLATFORM_SMS];
    
    //不同的分享方式就调用不用的show方法
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:nil cancelListener:onCancel failureListener:onFailure resultListener:onResult];
    
}

/**
 FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,
 FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,
 FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
 FRONTIA_SOCIAL_SHARE_PLATFORM_COPY,
 FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,
 FRONTIA_SOCIAL_SHARE_PLATFORM_SMS
 */
+ (void) shareWithContent:(FrontiaShareContent *)content sharePlatform:(NSString *)platform
{
    FrontiaShare *share = [Frontia getShare];
    
    //微信的appid,新浪等其他的不用填
    [share registerWeixinAppId:APPID_WEIXIN];
    
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
//        [ShareMethod showResultWithPlatform:platform success:NO content:content];
        [GlobalConfig showAlertViewWithMessage:@"授权失败，请重新授权" superView:nil];
    };
    
    //授权成功回调函数
    FrontiaSingleShareResultCallback onResult = ^{
        [ShareMethod showResultWithPlatform:platform success:YES content:content];
    };
    
    
    [share shareWithPlatform:platform content:content supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

+ (void) showResultWithPlatform:(NSString *)platform success:(BOOL)success content:(FrontiaShareContent *)content
{
    if (success) {
        if ([platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_SMS] || [platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL]) {
            [GlobalConfig showAlertViewWithMessage:@"发送成功" superView:nil];
        }
        else if ([platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_COPY]) {
            [GlobalConfig showAlertViewWithMessage:[NSString stringWithFormat:@"复制成功%@",content.url] superView:nil];
        }
        else {
//            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                sleep(1000);
//                dispatch_sync(dispatch_get_main_queue(), ^{
            
//                [GlobalConfig showAlertViewWithMessage:@"分享成功" success:NZAlertStyleSuccess];
            [GlobalConfig showAlertViewWithMessage:@"分享成功" superView:nil];
//                });
//                
//            });
        }
    }
    else {
        if ([platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_SMS] || [platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL]) {
            [GlobalConfig showAlertViewWithMessage:@"发送失败，请重新发送" superView:nil];
        }
        else if ([platform isEqualToString:FRONTIA_SOCIAL_SHARE_PLATFORM_COPY]) {
            [GlobalConfig showAlertViewWithMessage:@"复制失败，请重新复制" superView:nil];
        }
        else {
            [GlobalConfig showAlertViewWithMessage:@"分享失败，请重新分享" superView:nil];
        }
    }
}



@end
