//
//  Ticket.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Ticket : BaseModel

@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, strong) NSString *ticket_name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *cou_num;
@property (nonatomic, strong) NSString *sur_num;
@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *event_title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *is_free;
@property (nonatomic, strong) NSString *original_price;
@property (nonatomic, strong) NSString *lowest_sell;
@property (nonatomic, strong) NSString *highest_sell;
@property (nonatomic, strong) NSString *ticket_num;

@end
