//
//  CustomTabbar.h
//  MoshActivity
//
//  Created by  evafan2003 on 12-12-29.
//  Copyright (c) 2012年 cn.mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    TabbarTypeButton, //底部 用于替换tabbar
    TabbarTypeTop,  //顶端
    TabbarTypeSearch    //搜索
}TabbarType;
@protocol CustomTabbarDelegate;

@interface CustomTabbar : UIView

@property (nonatomic, retain) UIView *aView;
@property (nonatomic, assign) TabbarType tabbarType;

@property (assign, nonatomic) id<CustomTabbarDelegate> customTabbarDelegate;

-(void)setButtons:(NSArray *)buttonArray;

@end

//委托
@protocol CustomTabbarDelegate

-(void) switchTabBar:(id)sender;

@end

//---------------------------------------------------------------------------

//活动筛选条
typedef enum GATypeChooseViewType {
    
    GATypeChooseViewTypeOrder,   //排序
    GATypeChooseViewTypeDis,    //距离
    GATypeChooseViewTypeCate    //分类
} GATypeChooseViewType;

@interface GATypeChooseView : UIControl
{
    NSArray *array_;
    
    UIScrollView *scrollView_;
    UIView       *selectView_;
    
    int      selTag_;
    
    float    cWidth_;
}
@property (nonatomic) GATypeChooseViewType GATypeChooseViewType;
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, readonly) int selTag;

- (void) show;

@end
