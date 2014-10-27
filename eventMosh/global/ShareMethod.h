//
//  ShareMethod.h
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Frontia/Frontia.h>

@interface ShareMethod : NSObject
/**
 *  分享到多平台
 *
 *  @param content 分享内容
 */
+ (void) shareWithContent:(FrontiaShareContent *)content;

/**
 FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,
 FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,
 FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
 FRONTIA_SOCIAL_SHARE_PLATFORM_COPY,
 FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,
 FRONTIA_SOCIAL_SHARE_PLATFORM_SMS
 */
+ (void) shareWithContent:(FrontiaShareContent *)content sharePlatform:(NSString *)platform;

@end
