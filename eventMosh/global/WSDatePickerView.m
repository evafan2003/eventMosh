//
//  WSDatePickerView.m
//  TaskAlert
//
//  Created by 魔时网 on 14-3-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "WSDatePickerView.h"
#import "GlobalConfig.h"

static CGFloat  toolBarHeight = 30.0f;
static CGFloat pickerHeight = 216.0f;

@implementation WSDatePickerView

- (id)initWithFrame:(CGRect)frame dataPickerMode:(UIDatePickerMode)mode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.mode = mode;
    }
    return self;
}

- (id) initWithdataPickerMode:(UIDatePickerMode)mode
{
    self = [super initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, toolBarHeight + pickerHeight)];
    if (self) {
        // Initialization code
        self.mode = mode;
        self.isShow = NO;
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, toolBarHeight)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    toolBar.items = [NSArray arrayWithObjects:space,done, nil];
    [self addSubview:toolBar];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 , toolBarHeight ,SCREENWIDTH , pickerHeight)];

    self.datePicker.datePickerMode = self.mode;
    self.datePicker.backgroundColor = CLEARCOLOR;
    [self addSubview:self.datePicker];
    
//    [self ShowPickerView];
}

- (NSDate *) currentDate
{
    return self.datePicker.date;
}


-(void)ShowPickerView
{
        if (!self.isShow) {
            [self.superview bringSubviewToFront:self];
        //    if (self.frame.origin.y < SCREENHEIGHT) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = CGRectOffset(self.frame, 0, - self.frame.size.height);
                }];
        //    }
            self.isShow = YES;
        }
    
}
//PickerView Disappear
-(void)removePickerView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

-(void)hiddenPickerView
{
    if (self.isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
            self.isShow = NO;
    }
}




- (void)done
{
    if ([self.delegate respondsToSelector:@selector(wsdatePickerSelectDate:mode:)]) {
        [self.delegate wsdatePickerSelectDate:self.datePicker.date mode:self.mode];
    }
    [self hiddenPickerView];
    
}


@end
