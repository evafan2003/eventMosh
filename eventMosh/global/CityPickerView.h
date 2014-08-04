//
//  CityPickerView.h
//  MoshActivity
//
//  Created by mosh on 13-5-7.
//  Copyright (c) 2013年 com.mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityPickerViewDelegate <NSObject>

- (void) doneWithSelectCity:(NSString *)cityName;

@end

@interface CityPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *provinceArray;
    NSArray *cityArray;
    NSMutableDictionary *totalCityDic;
    UIPickerView *pickView;
}
@property (assign, nonatomic) id <CityPickerViewDelegate> delegate;

- (void) removePickerView;

@end
