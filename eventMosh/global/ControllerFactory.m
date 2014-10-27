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
#import "ActivityOrderViewController.h"
#import "FavoriteController.h"
#import "ActivityStatisticalViewController.h"
#import "TicketStatistical.h"

#import "TicketStatisticalViewController.h"
#import "ResourceStatisticalViewController.h"
#import "PartSaleTaskViewController.h"

@implementation ControllerFactory

static DDMenuController *menuController = nil;
static LeftViewController *leftContrller = nil;


+ (UIViewController *) controllerWithloginIn
{
    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:[[NSUserDefaults standardUserDefaults] objectForKey:USER_USERNAME]] && [GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:[[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD]] ) {
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

//票种管理
+(UIViewController *) favoriteListViewController {
    return [FavoriteController viewController];
}

//票种详情
+ (UIViewController *) ticketDetailControllerWithTicket:(Ticket *)ticket {
    return [[TicketDetailViewController alloc] initWithNibName:NSStringFromClass([TicketDetailViewController class]) bundle:nil ticket:ticket];
}

+ (UIViewController *) webViewControllerWithTitle:(NSString *)title Url:(NSString *)url showToolBar:(BOOL)show act:(NSString*)act
{
    return [[WebViewController  alloc] initWithTitle:title URL:[NSURL URLWithString:url] showToolBar:show act:act];
}

+(UIViewController *) posListViewController {
    return [ActivityOrderViewController viewController];
}


+ (UIViewController *) activityStatisticalWithActivity:(Activity *)act
{
    return [[ActivityStatisticalViewController alloc] initWithNibName:NSStringFromClass([ActivityStatisticalViewController class]) bundle:nil activity:act];
}

+ (UIViewController *) ticketStatisticalWithData:(NSMutableArray *)array activity:(Activity *)act
{
    return [[TicketStatisticalViewController alloc] initWithActivity:act dataArray:array];
}

+ (UIViewController *) resourceStatisticalWithData:(NSMutableArray *)array activity:(Activity *)act
{
    return [[ResourceStatisticalViewController alloc] initWithActivity:act dataArray:array];
}

+ (UIViewController *) partSaleTaskViewControllerWithData:(NSMutableArray *)array activity:(Activity *)act
{
    return [[PartSaleTaskViewController alloc] initWithActivity:act dataArray:array];
}

//+ (UIViewController *) singleresourceStaViewControllerWithResourceStatistical:(ResourceStatistical *)res
//{
//    return [[SingleResourceStaViewController alloc] initWithNibName:NSStringFromClass([SingleResourceStaViewController class]) bundle:nil resourceStatistical:res];
//}
//
//+ (UIViewController *) singleTicketStaViewControllerWithTicketStatistical:(TicketStatistical *)tic
//{
//    return [[SingleTicketStatisticalViewController alloc] initWithTicketStatistical:tic];
//}

@end
