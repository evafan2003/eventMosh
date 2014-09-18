//
//  ActivityViewController.h
//  moshTickets
//
//  Created by 魔时网 on 13-11-18.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

/*
 
 活动列表
 
 */

#import "BaseTableViewController.h"
#import "ActivityCell.h"
#import "Activity.h"
#import "ActivitySearchController.h"

@interface ActivityViewController : BaseTableViewController<ActivityCellDelegate,ActivitySearchDelegate>

@end
