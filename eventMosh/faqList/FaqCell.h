//
//  FaqCell.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *faqTitle;
@property (weak, nonatomic) IBOutlet UILabel *faqtime;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
