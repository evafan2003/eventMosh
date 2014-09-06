//
//  Order.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Order :BaseModel

@property (nonatomic, strong) NSString *o_id;
@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *e_title;
@property (nonatomic, strong) NSString *o_money;
@property (nonatomic, strong) NSString *t_count;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *order_state;
@property (nonatomic, strong) NSString *order_date;
@property (nonatomic, strong) NSString *pay_date;
@property (nonatomic, strong) NSString *is_v;
@property (nonatomic, strong) NSString *v_price;
@property (nonatomic, strong) NSString *browser_type;
@property (nonatomic, strong) NSString *order_way;

@end
