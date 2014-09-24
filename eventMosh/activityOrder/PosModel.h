//
//  PosModel.h
//  eventMosh
//
//  Created by  evafan2003 on 14-9-9.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseModel.h"

@interface PosModel : BaseModel

@property (nonatomic, strong) NSString *eid;//活动id
@property (nonatomic, strong) NSString *bz;//币种
@property (nonatomic, strong) NSString *title;//活动标题
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *c;//订单数
@property (nonatomic, strong) NSString *o_money;//售票额
@property (nonatomic, strong) NSString *t_count;//售票数
@property (nonatomic, strong) NSString *succ;//成功订单
@property (nonatomic, strong) NSString *orgname;//主办方
@property (nonatomic, strong) NSString *a;//点击数

@end
