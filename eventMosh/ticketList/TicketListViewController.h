//
//  TicketListViewController.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseTableViewController.h"

#import "TicketSearchViewController.h"

@interface TicketListViewController : BaseTableViewController<TicketSearchDelegate>
@property (nonatomic, strong) NSString *searchString;
@end
