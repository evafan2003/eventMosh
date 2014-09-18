//
//  BaseViewController.m
//  modelTest
//
//  Created by mosh on 13-10-21.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "GlobalConfig.h"

static UIButton *menuButton;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([GlobalConfig versionIsIOS7]) {
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[ControllerFactory getSingleDDMenuController] gestureSetEnable:YES isShowRight:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND;
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    //loadingView
    [self createLoadingView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//私有方法 不需要写在.h文件中
#pragma privateAction
- (void) createLoadingView
{
    self.loadingView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.loadingView];
    [self hideLoadingView];
}

//受保护方法 继承类可用
#pragma protectAction
- (void) showLoadingView
{
    self.loadingView.labelText = [self returnLoadingViewLabelText];
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingView show:YES];
}

- (void)showProgressDialog:(int)current total:(int)total complete:(void (^)(void))complete {
    
    //设置模式为进度框形的
    self.loadingView.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self.loadingView showAnimated:YES whileExecutingBlock:^{

            self.loadingView.progress = current;
            usleep(total);
        
    } completionBlock:^{
//        complete();
        [self hideLoadingView];
        
    }];
}

- (void) hideLoadingView
{
    [self.loadingView hide:YES];
}

- (NSString *) returnLoadingViewLabelText
{
    return LOADING;
}


+ (BaseViewController *) viewController
{
    return [[self alloc] init];
}

+ (BaseViewController *) viewControllerWithNib
{
    return [[self alloc] initWithNibName:NSStringFromClass(self.class) bundle:nil];
}

//公共方法
#pragma publicAction

- (void) createBarWithLeftBarItem:(MoshNavigationBarItemType)leftItem
                     rightBarItem:(MoshNavigationBarItemType)rightItem
                            title:(NSString *)title
{
    self.title = title;
    
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithBarItemType:leftItem isLeft:YES];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithBarItemType:rightItem isLeft:NO];
    
}

- (UIBarButtonItem *) barButtonItemWithBarItemType:(MoshNavigationBarItemType)type isLeft:(BOOL)isLeft
{
    switch (type) {
        case MoshNavigationBarItemBack:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_back highlightImageName:NAVBUTTON_back_h title:nil isLeft:isLeft action:@selector(navBackClick) target:self];
            break;
        case MoshNavigationBarItemList:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_list highlightImageName:NAVBUTTON_list_h title:nil isLeft:isLeft action:@selector(navListClick) target:self];
            break;
        case MoshNavigationBarItemshare:
           return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_share highlightImageName:NAVBUTTON_share_h title:nil isLeft:isLeft action:@selector(navShareClick) target:self];
            break;
        case MoshNavigationBarItemUser:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_user highlightImageName:NAVBUTTON_user_h title:nil isLeft:isLeft action:@selector(navUserClick) target:self];
            break;
        case MoshNavigationBarItemUserExited:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_exit highlightImageName:NAVBUTTON_exit_h title:nil isLeft:isLeft action:@selector(navUserExitClick) target:self];
            break;
        case MoshNavigationBarItemDelete:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_delete highlightImageName:NAVBUTTON_delete_h title:nil isLeft:isLeft action:@selector(navDeleteClick) target:self];
            break;
        case MoshNavigationBarItemRefresh:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_refresh highlightImageName:NAVBUTTON_refresh_h title:nil isLeft:isLeft action:@selector(navRefreshClick) target:self];
            break;
        case MoshNavigationBarItemCheck:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_check highlightImageName:NAVBUTTON_check_h title:nil isLeft:isLeft action:@selector(navCheckClick)target:self];
            break;
        case MoshNavigationBarItemAdd:
            return [BaseViewController createNavigationBarItemWithNormalImageName:NAVBUTTON_add highlightImageName:NAVBUTTON_add_h title:nil isLeft:isLeft action:@selector(navAddClick)target:self];
            break;
        case MoshNavigationBarItemNone:
            return nil;
            break;
        default:
            return nil;
            break;
    }
}

+ (UIBarButtonItem *) createNavigationBarItemWithNormalImageName:(NSString *)normalImageName
                                              highlightImageName:(NSString *)highlightImageName
                                                           title:(NSString *)title
                                                          isLeft:(BOOL)isLeft
                                                          action:(SEL)action
                                                          target:(id)vtl
{
    UIView *view = [GlobalConfig createViewWithFrame:CGRectMake( 0, 0, 44, 44)];
//    view.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:normalImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    if ([title length] != 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    [button addTarget:vtl action:action forControlEvents:UIControlEventTouchUpInside];
//    CGFloat pointX = 0;
//    if ([GlobalConfig versionIsIOS7]) {
//        pointX = (isLeft ? -10 : 6);
//    }
    if (image) {
        button.frame = CGRectMake((CGRectGetWidth(view.frame) - image.size.width),(CGRectGetHeight(view.frame) - image.size.height)/2,image.size.width,image.size.height);
    }
    else {
        button.frame = view.frame;
    }
    [view addSubview:button];
    UIBarButtonItem *iteml = [[UIBarButtonItem alloc] initWithCustomView:view];
    return iteml;
}

- (void) downloadData
{
    
}

- (void) navListClick
{
}

- (void) navBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) navUserClick
{
}
- (void) navShareClick
{

}

- (void) navUserExitClick
{
    [GlobalConfig deleteUserInfo];
}

- (void) navDeleteClick
{
    
}

- (void) navRefreshClick
{
    
}

- (void) navCheckClick
{
    
}

- (void) navAddClick
{

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}
#pragma mark - uitextFieldDelegate -
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//设置发布状态
-(NSString *) setStatus:(NSString *)status {
    
    NSString *value;
    switch ([status intValue]) {
        case 1:
            value = @"已审核";
            break;
        case 2:
            value = @"未审核";
            break;
        case 3:
            value = @"取消";
            break;
        case 4:
            value = @"暂停";
            break;
        case 5:
            value = @"发布中修改待审核";
            break;
        case 6:
            value = @"已删除";
            break;
        case 7:
            value = @"审核未通过";
            break;
        default:
            break;
    }
    return value;
}

//设置售票状态
-(NSString *) setSellStatus:(NSString *)status {
    NSString *value;
    if ([status isEqualToString:@"notStarted"]) {
        value = @"未开始";
    } else if ([status isEqualToString:@"ing"]) {
        value = @"售票中";
    } else {
        value = @"售票结束";
    }
    return value;
}

//设置结款状态
-(NSString *) setIsAllpay:(NSString *)status {
    NSString *value;
    switch ([status intValue]) {
        case 1:
            value = @"未结款";
            break;
        case 2:
            value = @"已结款";
            break;
        case 3:
            value = @"已取消";
            break;
        case 4:
            value = @"已申请";
            break;
        default:
            break;
    }
    return value;
}

-(void) setMenuButton {
    
    //菜单button
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(10, SCREENHEIGHT-NAVHEIGHT-44-20, 50, 50);
    menuButton.backgroundColor = [UIColor grayColor];
    [menuButton setImage:[UIImage imageNamed:NAVBUTTON_list] forState:UIControlStateNormal];
    menuButton.alpha = 0.9;
    [menuButton addTarget:self action:@selector(navListClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    [self.view bringSubviewToFront:menuButton];
}


@end
