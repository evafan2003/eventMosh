//
//  ActivityCell.h
//  moshTickets
//
//  Created by 魔时网 on 13-11-18.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityCellDelegate;


@interface ActivityCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityDate;
@property (weak, nonatomic) IBOutlet UILabel *status;//活动状态
@property (weak, nonatomic) IBOutlet UILabel *ticket_status;//售票状态
@property (weak, nonatomic) IBOutlet UILabel *is_allpay;//结款状态
@property (weak, nonatomic) IBOutlet UILabel *sell_ticket_num;//成功订单
@property (weak, nonatomic) IBOutlet UILabel *sell_ticket_money;//票款
@property (weak, nonatomic) IBOutlet UILabel *contact;//联系人
@property (nonatomic, assign) id<ActivityCellDelegate> delegate;

@end



@protocol ActivityCellDelegate <NSObject>

@end