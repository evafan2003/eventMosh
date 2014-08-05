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
#import "DraftViewController.h"
#import "DraftDetailViewController.h"
#import "FaqViewController.h"
#import "FaqDetailViewController.h"
#import "OrderListViewController.h"
#import "TicketListViewController.h"
#import "TicketDetailViewController.h"

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

//审核管理列表
+(UIViewController *) draftListViewController {
    return [DraftViewController viewController];
}

//审核管理详情
+ (UIViewController *) draftDetailControllerWithDraft:(Draft *)act {
    return [[DraftDetailViewController alloc] initWithNibName:NSStringFromClass([DraftDetailViewController class]) bundle:nil draft:act];
}

//咨询列表
+(UIViewController *) faqListViewController {
    return [FaqViewController viewController];
}

//咨询详情
+ (UIViewController *) faqDetailControllerWithFaq:(Faq *)faq {
    return [[FaqDetailViewController alloc] initWithNibName:NSStringFromClass([FaqDetailViewController class]) bundle:nil faq:faq];
}

//订单管理
+(UIViewController *) orderListViewController {
    return [OrderListViewController viewController];
}

//票种管理
+(UIViewController *) ticketListViewController {
    return [TicketListViewController viewController];
}

//票种详情
+ (UIViewController *) ticketDetailControllerWithTicket:(Ticket *)ticket {
    return [[TicketDetailViewController alloc] initWithNibName:NSStringFromClass([TicketDetailViewController class]) bundle:nil ticket:ticket];
}

+ (UIViewController *) webViewControllerWithTitle:(NSString *)title Url:(NSString *)url
{
    return [[WebViewController  alloc] initWithTitle:title URL:[NSURL URLWithString:url]];
}

@end
