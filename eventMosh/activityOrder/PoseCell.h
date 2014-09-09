//
//  PoseCell.h
//  eventMosh
//
//  Created by  evafan2003 on 14-9-9.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sold_num;
@property (weak, nonatomic) IBOutlet UILabel *sold_price;
@property (weak, nonatomic) IBOutlet UILabel *succ_order;
@property (weak, nonatomic) IBOutlet UILabel *order;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UILabel *pub;

@end
