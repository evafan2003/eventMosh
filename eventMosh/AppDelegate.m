//
//  AppDelegate.m
//  eventMosh
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//
/*code is far away from bug with the animal protecting
 * ┏┓　　　 ┏┓
 *┏┛┻━━━━━━┛┻┓
 *┃　　　　　　┃
 *┃　　 ━     ┃
 *┃　┳┛　 ┗┳　┃
 *┃　　　　　　┃
 *┃　　 ┻　　　┃
 *┃　　　　　　┃
 *┗━┓　　　┏━┛
 *  ┃　　　┃   神兽保佑
 *  ┃　　　┃   代码无BUG！
 *  ┃　　　┗━━━┓
 *  ┃　　　　　 ┣┓
 *  ┃　　　　　 ┏┛
 *  ┗┓┓┏━━━┳┓┏┛
 *　　┃┫┫　┃┫┫
 *　　┗┻┛　┗┻┛
 *
 */
#import "AppDelegate.h"
#import "ControllerFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //左右滑屏
    self.menuController = [ControllerFactory getSingleDDMenuController];
    //左屏
    LeftViewController *left = [ControllerFactory getSingleLeftViewController];
    self.menuController.leftViewController = left;
    self.menuController.rootViewController =  [[BaseNavigationController alloc] initWithRootViewController:[ControllerFactory controllerWithloginIn]];
    
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
    
    
    //主屏
//    [left startFirstPage];
    
    //初始化百度Frontia
    [Frontia initWithApiKey:APPKEY_BAIDU];
    
    
    self.window.rootViewController = self.menuController;
    [self.window makeKeyAndVisible];
    return YES;

//    UIViewController * vc = [[UIViewController alloc] init];
//    self.window.backgroundColor = [UIColor clearColor];

    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(60, 200, 200, 100);
    [button setTitle:@"打印" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:button]; 
 
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
     */
}

-(void)print{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://su.bdimg.com/static/superplus/img/logo_white.png"]];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if  (pic && [UIPrintInteractionController canPrintData: data] ) {
        
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"百度";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = data;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %ld",error.domain, (long)error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            [pic presentFromBarButtonItem:self.printButton animated:YES completionHandler:completionHandler];
            NSLog(@"不知道这是啥啊");
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
