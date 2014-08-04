//
//  WSPickerView.h
//  SaleDemo
//
//  Created by wuzhensong on 14-4-28.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

//frame为固定值（x,x,320,216+30）;

@protocol WSPickerViewDelegate;

@interface WSPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic , assign) id<WSPickerViewDelegate> delegate;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *dataArray;

- (id) initWithDataArray:(NSArray *)array;
- (void) removeWSPickerView;
@end

@protocol WSPickerViewDelegate <NSObject>

- (void) wsPickerSelectIndex:(NSInteger)index pickerView:(WSPickerView *)view;

@end

