//
//  WSPickerView.m
//  SaleDemo
//
//  Created by wuzhensong on 14-4-28.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "WSPickerView.h"
#import "GlobalConfig.h"


static CGFloat  toolBarHeight = 30.0f;
static CGFloat pickerHeight = 216.0f;

@implementation WSPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithDataArray:(NSArray *)array
{
    self = [super initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, toolBarHeight + pickerHeight)];
    if (self) {
        // Initialization code
        self.dataArray = array;
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
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBarHeight, SCREENWIDTH, pickerHeight)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = CLEARCOLOR;
    [self addSubview:self.pickerView];
    
    [self ShowPickerView];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < self.dataArray.count) {
        return self.dataArray[row];
    }
    return @"";
}

-(void)ShowPickerView
{
    //    if (self.frame.origin.y < SCREENHEIGHT) {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectOffset(self.frame, 0, - self.frame.size.height);
    }];
    //    }
    
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

- (void)done
{
    if ([self.delegate respondsToSelector:@selector(wsPickerSelectIndex:pickerView:)]) {
    [self.delegate wsPickerSelectIndex:[self.pickerView selectedRowInComponent:0] pickerView:self];
    }
    [self removePickerView];
}

- (void) removeWSPickerView
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
