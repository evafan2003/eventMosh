//
//  PoseCell.m
//  eventMosh
//
//  Created by  evafan2003 on 14-9-9.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "PoseCell.h"

@implementation PoseCell
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"活动统计》" forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.frame = CGRectMake(226, 99, 87, 38);
    [button setTitleColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkResult:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)checkResult:(id)sender {
    [self.delegate checkStatisticalWithCell:self];
}
@end
