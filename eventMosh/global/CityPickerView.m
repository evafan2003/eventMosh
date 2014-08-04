//
//  CityPickerView.m
//  MoshActivity
//
//  Created by mosh on 13-5-7.
//  Copyright (c) 2013年 com.mosh. All rights reserved.
//

#import "CityPickerView.h"
#import "GlobalConfig.h"

@implementation CityPickerView
@synthesize delegate;

static NSString *_cityName = @"CityName";     //城市名称

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
        [self ShowPickerView:self];
    }
    return self;
}

- (void) makeView
{
    
    provinceArray = [[NSMutableArray alloc] initWithCapacity:0];
    totalCityDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    CGSize pickSize=[pickView sizeThatFits:CGSizeZero];
    
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    pickView.frame = CGRectMake(0, 30, 320, pickSize.height);
    [self addSubview:pickView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    toolBar.items = [NSArray arrayWithObjects:space,done, nil];
    
    [self addSubview:toolBar];
    
    self.frame = CGRectMake(0,screenRect.size.height, 320, pickSize.height + 30);
     [self getCityName];
}

#pragma mark - pickViewDataSouce -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [provinceArray count];
    }
    else {
        return [cityArray count];
    }
}

#pragma mark - pickViewDelegate -


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *province = [provinceArray objectAtIndex:row];
        cityArray = [totalCityDic objectForKey:province];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [provinceArray objectAtIndex:row];
    }
    else {
        return [cityArray objectAtIndex:row];
    }
}

- (void) getCityName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Provinces" ofType:@"plist"];
    NSArray *provinces = [NSArray arrayWithContentsOfFile:path];
    
    if ([provinces isKindOfClass:[NSArray class]]) {

        for (NSDictionary *province in provinces) {
            NSString *provinceName = [province objectForKey:@"ProvinceName"];

            [provinceArray addObject:provinceName];

            NSArray *citys = [province objectForKey:@"cities"];
            NSMutableArray *citysArray = [[NSMutableArray alloc] initWithCapacity:0];

            for (NSDictionary *city in citys) {
                NSString *cityName = [city objectForKey:_cityName];
                [citysArray addObject:cityName];
            }

            [totalCityDic setObject:citysArray forKey:provinceName];
        }
    }
    [pickView reloadAllComponents];
    [self pickerView:pickView didSelectRow:0 inComponent:0];
}

-(void)ShowPickerView:(UIView *)view
{
    if(view.superview==nil)
    {
        CGRect screenRect=[[UIScreen mainScreen] bounds];
        CGRect pickRect=CGRectMake(0.0,screenRect.size.height - view.frame.size.height,320,view.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        view.frame=pickRect;
        [UIView commitAnimations];
    }
    
}
//PickerView Disappear
-(void)PickerViewDisappear:(UIView *)view
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect endFrame = CGRectMake(0, screenRect.size.height, 320, view.frame.size.height);
    endFrame.origin.y=screenRect.origin.y+screenRect.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    view.frame=endFrame;
    [UIView commitAnimations];
    
    [self removeFromSuperview];
    
}

- (void) done
{
    NSInteger row1 = [pickView selectedRowInComponent:0];
    NSInteger row2 = [pickView selectedRowInComponent:1];
    if (row1 < [provinceArray count] && row2 < [cityArray count]) {
        NSString *province = [provinceArray objectAtIndex:row1];
        NSString *city = [cityArray objectAtIndex:row2];
        NSString *name = [NSString stringWithFormat:@"%@%@",province,city];
        [self.delegate doneWithSelectCity:name];
    }
    [self PickerViewDisappear:self];
}

- (void) removePickerView
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}



@end
