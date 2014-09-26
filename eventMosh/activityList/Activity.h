//
//  Activity.h
//  moshTickets
//
//  Created by 魔时网 on 13-11-18.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Activity : BaseModel

@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *imageUrl;//图片url
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *start_date;//开始时间
@property (nonatomic, strong) NSString *end_date;//结束时间
@property (nonatomic, strong) NSString *status;//发布状态
@property (nonatomic, strong) NSString *is_allpay;//结款状态
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *sell_status;//售票状态
@property (nonatomic, strong) NSString *sell_order_num;//成功订单
@property (nonatomic, strong) NSString *sell_ticket_num;//售票
@property (nonatomic, strong) NSString *sell_ticket_money;//票款
@property (nonatomic, strong) NSString *issue_name;//联系人
@property (nonatomic, strong) NSString *issue_tel;//联系电话

//实验用活动
//@property (nonatomic, strong) NSString *eid;//活动id
@property (nonatomic, strong) NSString *bz;//币种
//@property (nonatomic, strong) NSString *title;//活动标题
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *c;//订单数
@property (nonatomic, strong) NSString *o_money;//售票额
@property (nonatomic, strong) NSString *t_count;//售票数
@property (nonatomic, strong) NSString *succ;//成功订单
@property (nonatomic, strong) NSString *orgname;//主办方
@property (nonatomic, strong) NSString *a;//点击数

+ (Activity *) activity:(NSDictionary *)dic;


@end
