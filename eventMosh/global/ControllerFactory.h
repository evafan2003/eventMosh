//
//  ControllerFactory.h
//  CoolProject
//
//  Created by 魔时网 on 14-6-3.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConfig.h"
#import "HTTPClient.h"

#import "MoshNavigationController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
//#import "LoginViewController.h"
#import "BaseNavigationController.h"
//#import "UserInfoViewController.h"
//#import "PasswordViewController.h"
//#import "WebViewController.h"
#import "Activity.h"
#import "Draft.h"
#import "Faq.h"
#import "Order.h"
#import "Ticket.h"



@interface ControllerFactory : NSObject

//菜单
+ (DDMenuController *) getSingleDDMenuController;
+ (LeftViewController *) getSingleLeftViewController;
+ (MoshNavigationController *) createNavigationControllerWithRootViewController:(UIViewController *)rootCtl;


//返回登录页面的Controller
+ (UIViewController *) controllerWithloginIn;

//登录成功 进入活动列表
+(UIViewController *) controllerWithLoginSuccess;

//登录页面的Controller
+ (UIViewController *) loginInViewController;

//忘记密码
+(UIViewController *) controllerWithForgetPassWord;

//活动列表
+(UIViewController *) activityListViewController;

//活动详情
+ (UIViewController *) actDetailControllerWithActivity:(Activity *)act;

//审核列表
+(UIViewController *) draftListViewController;

//审核详情
+ (UIViewController *) draftDetailControllerWithDraft:(Draft *)act;

//咨询列表
+(UIViewController *) faqListViewController;
//咨询详情
+ (UIViewController *) faqDetailControllerWithFaq:(Faq *)act;

//订单查询
+(UIViewController *) orderListViewController;

//票种管理
+(UIViewController *) ticketListViewController;

//票种管理
+(UIViewController *) favoriteListViewController;

//票种详情
+ (UIViewController *) ticketDetailControllerWithTicket:(Ticket *)ticket;

//网页
+ (UIViewController *) webViewControllerWithTitle:(NSString *)title Url:(NSString *)url showToolBar:(BOOL)show act:(NSString*)act;


+(UIViewController *) posListViewController;
//活动统计
+ (UIViewController *) activityStatisticalWithActivity:(Activity *)act;



//活动列表
+(UIViewController *) activityListViewController;

//活动统计
+ (UIViewController *) activityStatisticalWithActivity:(Activity *)act;

//票统计
+ (UIViewController *) ticketStatisticalWithData:(NSMutableArray *)array activity:(Activity *)act;

//来源统计
+ (UIViewController *) resourceStatisticalWithData:(NSMutableArray *)array activity:(Activity *)act;

//分销任务统计
+ (UIViewController *) partSaleTaskViewControllerWithData:(NSMutableArray *)array activity:(Activity *)act;

////圆环图
//+ (UIViewController *) singleresourceStaViewControllerWithResourceStatistical:(ResourceStatistical *)res;
//
////饼图
//+ (UIViewController *) singleTicketStaViewControllerWithTicketStatistical:(TicketStatistical *)tic;


@end
