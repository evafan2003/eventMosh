//
//  DraftCell.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *draftTitle;//活动标题
@property (weak, nonatomic) IBOutlet UILabel *draftDate;//发布时间
@property (weak, nonatomic) IBOutlet UILabel *status;//活动状态
@property (weak, nonatomic) IBOutlet UILabel *user_name;//用户名
@property (weak, nonatomic) IBOutlet UILabel *type;//类别
@property (weak, nonatomic) IBOutlet UILabel *publisher;//发布人
@property (weak, nonatomic) IBOutlet UILabel *company;//主办方
@end
