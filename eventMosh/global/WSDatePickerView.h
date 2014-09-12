//
//  WSDatePickerView.h
//  TaskAlert
//
//  Created by 魔时网 on 14-3-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>

//frame为固定值（x,x,320,216+30）;

@protocol WSDatePickerViewDelegate;

@interface WSDatePickerView : UIView

@property (nonatomic , assign) id<WSDatePickerViewDelegate> delegate;
@property (nonatomic, strong) UIDatePicker  *datePicker;
@property (nonatomic, assign) UIDatePickerMode mode;

- (NSDate *) currentDate;
- (id) initWithdataPickerMode:(UIDatePickerMode)mode;
-(void)removePickerView;

@end

@protocol WSDatePickerViewDelegate <NSObject>

- (void) wsdatePickerSelectDate:(NSDate *)date mode:(UIDatePickerMode)mode;

@end
