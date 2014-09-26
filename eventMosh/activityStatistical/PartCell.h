//
//  PartCell.h
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartTaskModel.h"

@protocol PartCellDelegate;
@interface PartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *successOrder;
@property (weak, nonatomic) IBOutlet UILabel *ticketCount;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (nonatomic, assign) id<PartCellDelegate> delegate;
@property (nonatomic, strong) PartTaskModel *model;

- (IBAction)copy:(id)sender;
- (IBAction)share:(id)sender;

- (void) setValueForCell:(PartTaskModel *)model;

@end

@protocol PartCellDelegate <NSObject>

- (void) shareWithCell:(PartCell *)cell;

@end
