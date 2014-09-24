//
//  NSString+Encrypt.h
//  moshTickets
//
//  Created by 魔时网 on 14-5-30.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Encrypt)

//加密
- (NSString *) encrypt;

//解密
- (NSString *) decrypt;

@end
