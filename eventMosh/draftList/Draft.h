//
//  Draft.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Draft : BaseModel

@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *imageUrl;//图片url
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *creation_date;//发布时间
@property (nonatomic, strong) NSString *status;//活动状态
@property (nonatomic, strong) NSString *mosh_user;//用户名
@property (nonatomic, strong) NSString *class_name;//类别
@property (nonatomic, strong) NSString *issue_name;//发布人
@property (nonatomic, strong) NSString *orgname;//主办方

@end
