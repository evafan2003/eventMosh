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

+ (Activity *) activity:(NSDictionary *)dic;


@end
