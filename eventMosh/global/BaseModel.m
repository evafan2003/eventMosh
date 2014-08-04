//
//  BaseModel.m
//  CoolProject
//
//  Created by 魔时网 on 14-6-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
