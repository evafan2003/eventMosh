//
//  PartSaleTaskViewController.h
//  moshTickets
//
//  Created by 魔时网 on 14-5-16.
//  Copyright (c) 2014年 mosh. All rights reserved.
//
#import <Frontia/Frontia.h>
#import "BaseTableViewController.h"
#import "PartCell.h"
@interface PartSaleTaskViewController : BaseTableViewController<PartCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *alertView;
- (id) initWithActivity:(Activity *)act dataArray:(NSMutableArray *)array;

@end
