//
//  NSString+Encrypt.m
//  moshTickets
//
//  Created by 魔时网 on 14-5-30.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "NSString+Encrypt.h"
#import "WSEncryption.h"

static NSString *encryptKey = @"moshmosh";
@implementation NSString (Encrypt)

//加密
- (NSString *) encrypt
{
    return [WSEncryption encryptUseDES:self key:encryptKey];
}

//解密
- (NSString *) decrypt
{
    return [WSEncryption decryptUseDES:self key:encryptKey];
}

@end
