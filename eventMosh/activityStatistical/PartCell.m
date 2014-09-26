//
//  PartCell.m
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "PartCell.h"
#import "GlobalConfig.h"

@implementation PartCell

//- (void)awakeFromNib
//{
//    self.bgView.layer.shadowColor = BLACKCOLOR.CGColor;
//    self.bgView.layer.shadowOpacity = 0.3f;
//    self.bgView.layer.shadowRadius = 2;
//    self.bgView.layer.shadowOffset = CGSizeMake(0, 1);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setValueForCell:(PartTaskModel *)model
{
    self.model = model;
    self.title.text = model.name;
    self.peopleCount.text = [NSString stringWithFormat:@"到访量:%@/人",model.peppleCount];
    self.successOrder.text = [NSString stringWithFormat:@"成单量:%@/单",model.successOrder] ;
    self.ticketCount.text =[NSString stringWithFormat:@"售票数:%@/张",model.ticketCount] ;
    self.totalMoney.text = [NSString stringWithFormat:@"销售额:%@/%@",model.totalSales,    [GlobalConfig currencyConver:model.currency]];

}

- (IBAction)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.model.url;
    [GlobalConfig showAlertViewWithMessage:[NSString stringWithFormat:@"复制成功:%@",self.model.url] superView:nil];
}

- (IBAction)share:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(shareWithCell:)]) {
        [self.delegate shareWithCell:self];
    }

}
@end
