//
//  Faq.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Faq : BaseModel

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *email;//邮件
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sug_class;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sug_date;//发布时间
@property (nonatomic, strong) NSString *is_reply;//是否回复y,n
@property (nonatomic, strong) NSString *reply_date;
@property (nonatomic, strong) NSString *reply_content;
@property (nonatomic, strong) NSString *reply_email;
@property (nonatomic, strong) NSString *id_notice;

@end
