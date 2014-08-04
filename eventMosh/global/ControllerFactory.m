//
//  ControllerFactory.m
//  CoolProject
//
//  Created by 魔时网 on 14-6-3.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ControllerFactory.h"
#import "PasswordViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"

@implementation ControllerFactory

static DDMenuController *menuController = nil;
static LeftViewController *leftContrller = nil;


+ (UIViewController *) controllerWithloginIn
{
    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:[[NSUserDefaults standardUserDefaults] objectForKey:USER_USERID]] && [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFULT_LOGIN] isEqualToNumber:@YES]) {
        return [ControllerFactory controllerWithLoginSuccess];
    }
    return [ControllerFactory loginInViewController];
}

+ (DDMenuController *) getSingleDDMenuController
{
    if (!menuController) {
        menuController = [[DDMenuController  alloc] initWithRootViewController:nil];
    }
    return menuController;
}

+ (LeftViewController *) getSingleLeftViewController
{
    if (!leftContrller) {
        leftContrller = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    }
    return leftContrller;
}

+ (MoshNavigationController *) createNavigationControllerWithRootViewController:(UIViewController *)rootCtl
{
    MoshNavigationController *navController = [[MoshNavigationController alloc] initWithRootViewController:rootCtl];
    return navController;
}


+ (UIViewController *) loginInViewController
{
    return [LoginViewController viewControllerWithNib];
}

+(UIViewController *) controllerWithLoginSuccess
{
//    return [UserInfoViewController viewControllerWithNib];
    return [ActivityViewController viewController];
}

+(UIViewController *) controllerWithForgetPassWord
{
    return [PasswordViewController viewControllerWithNib];
}

//活动列表
+ (UIViewController *) activityListViewController
{
    return [ActivityViewController viewController];
}

//活动详情
+ (UIViewController *) actDetailControllerWithActivity:(Activity *)act
{
    return [[ActivityDetailViewController alloc] initWithNibName:NSStringFromClass([ActivityDetailViewController class]) bundle:nil activity:act];
}

+ (UIViewController *) webViewControllerWithTitle:(NSString *)title Url:(NSString *)url
{
    return [[WebViewController  alloc] initWithTitle:title URL:[NSURL URLWithString:url]];
}

@end
