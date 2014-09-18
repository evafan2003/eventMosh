//
//  CustomTabbar.m
//  MoshActivity
//
//  Created by  evafan2003 on 12-12-29.
//  Copyright (c) 2012年 cn.mosh. All rights reserved.
//

#import "CustomTabbar.h"

@implementation CustomTabbar
@synthesize aView;
@synthesize customTabbarDelegate;
@synthesize tabbarType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        aView.backgroundColor = [UIColor colorWithRed:0/255.0f green:185/255.0f blue:239/255.0f alpha:1];
        [self addSubview:aView];
    }
    return self;
}

-(void)setButtons:(NSArray *)buttonArray {
        
    for (int i =0; i<buttonArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320/buttonArray.count*i, 0, 320/buttonArray.count, self.frame.size.height);
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];

        if (self.tabbarType == TabbarTypeTop) {
            //我的活动
            [button setBackgroundImage:[UIImage imageNamed:i==0?@"navigation_focuse":@"navigation_normal"] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:[buttonArray objectAtIndex:i] forState:UIControlStateNormal];
//            [button setTitleColor:i==0?[UIColor orangeColor]:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:i==0?[UIColor colorWithRed:0/255.0f green:155/255.0f blue:228/255.0f alpha:1]:[UIColor clearColor]];
            
        }else if (self.tabbarType == TabbarTypeSearch) {
            //搜索
            button.frame = CGRectMake(321/buttonArray.count*i, 0, 321/buttonArray.count, self.frame.size.height);
            [button setTitle:[buttonArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"search_nav"] forState:UIControlStateNormal];
            
        } else {
            //tabbar
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:i==0?@"home_navigation_focused_0%d":@"home_navigation_0%d",i]] forState:UIControlStateNormal];
            
        }
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:button];
    }
}

-(void)buttonPressed:(id)sender {

    int i = 0;
    if (self.tabbarType == TabbarTypeTop) {
        //我的活动
        for (UIButton *button in [aView subviews]) {
            [button setBackgroundImage:[UIImage imageNamed:@"navigation_normal"] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            i++;
        }
        UIButton *button = (UIButton *)sender;
//        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0/255.0f green:155/255.0f blue:228/255.0f alpha:1]];
        [button setBackgroundImage:[UIImage imageNamed:@"navigation_focuse"] forState:UIControlStateNormal];
        [customTabbarDelegate switchTabBar:sender];
        
    } else if (self.tabbarType == TabbarTypeSearch) {
        //搜索
        for (UIButton *button in [aView subviews]) {
            [button setBackgroundImage:[UIImage imageNamed:@"search_nav"] forState:UIControlStateNormal];
            i++;
        }
        UIButton *button = (UIButton *)sender;
        [button setBackgroundImage:[UIImage imageNamed:@"search_focus_nav"] forState:UIControlStateNormal];
        [customTabbarDelegate switchTabBar:sender];
        
    } else {
        //
        for (UIButton *button in [aView subviews]) {
            
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_navigation_0%d.png",i]] forState:UIControlStateNormal];
            i++;
        }
        UIButton *button = (UIButton *)sender;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_navigation_focused_0%d.png",[sender tag]]] forState:UIControlStateNormal];
        [customTabbarDelegate switchTabBar:sender];
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GATypeChooseView
@synthesize selTag = selTag_;
@synthesize GATypeChooseViewType;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setArray:(NSArray *)array
{
//    int x = 21;
//    int y = 8;
    
    for (int i=0;i<array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.GATypeChooseViewType == GATypeChooseViewTypeCate) {
            
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cate_bg"]]];
            button.frame = CGRectMake(2+(i%4)*76, 5 + (i/4)*47, 76, 47);

            
        } else if (self.GATypeChooseViewType == GATypeChooseViewTypeDis) {

            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dis_bg"]]];
            if (i == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"dis_01"] forState:UIControlStateNormal];
            } else if (i == array.count-1) {
                [button setBackgroundImage:[UIImage imageNamed:@"dis_03"] forState:UIControlStateNormal];
            } else {
                [button setBackgroundImage:[UIImage imageNamed:@"dis_02"] forState:UIControlStateNormal];
            }
            button.frame = CGRectMake(2+i*61, 5, 61, 47);
            
        } else {
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"order_bg"]]];
            if (i == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"order_01"] forState:UIControlStateNormal];
            } else if (i == array.count-1) {
                [button setBackgroundImage:[UIImage imageNamed:@"order_03"] forState:UIControlStateNormal];
            } else {
                [button setBackgroundImage:[UIImage imageNamed:@"order_02"] forState:UIControlStateNormal];
            }
            button.frame = CGRectMake(2+i*101, 5, 101, 47);
            
        }
        
        [self addSubview:button];
        
    }
}

- (void) btnAct:(id)sender
{
    for (UIView *a in [self subviews]) {
        
        if ([a isKindOfClass:[UILabel class]]) {
            
            [a removeFromSuperview];
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+44, btn.frame.size.width, 3)];
    label.backgroundColor = [UIColor orangeColor];
    [self addSubview: label];
    selTag_ = [sender tag];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (selectView_.superview == nil) {
        [scrollView_ addSubview:selectView_];
        [scrollView_ sendSubviewToBack:selectView_];
    }
    
    selectView_.frame = btn.frame;
    [self removeFromSuperview];
}

- (NSArray *) array
{
    return array_;
}

- (void) show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end

