//
//  LeftViewController.m
//  Movie
//
//  Created by mosh on 13-5-26.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "LeftViewController.h"
#import "GlobalConfig.h"
#import "ControllerFactory.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND;

    self.rootNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory controllerWithloginIn]];
    self.actNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory activityListViewController]];
    self.newsNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory draftListViewController]];
    self.photoNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory orderListViewController]];
    self.weiboNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory faqListViewController]];
    self.moreNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory posListViewController]];
    self.partnerNav = [ControllerFactory createNavigationControllerWithRootViewController:[ControllerFactory ticketListViewController]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressWithTouchUpInside:(id)sender {
    UIButton *button = (UIButton *)sender;
//    UILabel *label = (UILabel *)[self.view viewWithTag:button.tag + 100];
//    
//    //按钮变红
//    UIButton *oldButton = (UIButton *)[self.view viewWithTag:self.selButtonTag];
//    UILabel *oldLabel = (UILabel *)[self.view viewWithTag:self.selButtonTag + 100];
//    [oldButton setImage:[UIImage imageNamed:@"cate_cell"] forState:UIControlStateNormal];
//    oldLabel.textColor = TEXTGRAYCOLOR;
//    
//    [button setImage:[UIImage imageNamed:@"cate_cell02"] forState:UIControlStateNormal];
//    label.textColor = [UIColor whiteColor];
    self.selButtonTag = button.tag;
    
    DDMenuController *menuController = [ControllerFactory getSingleDDMenuController];
    
//    if (button.tag == 101) {
//        //首页
//        [menuController setRootController:self.rootNav animated:YES];
//    }
//    else
    if (button.tag == 102) {
        //活动
        [menuController setRootController:self.actNav animated:YES];
    }
    else if (button.tag == 103) {
        //新闻
        [menuController setRootController:self.newsNav animated:YES];

    }
    else if (button.tag == 104) {
        //微博
        [menuController setRootController:self.weiboNav animated:YES];
    }
    else if (button.tag == 105) {
        //现场图集
        [menuController setRootController:self.photoNav animated:YES];
        
    }
    else if (button.tag == 106) {
        //合作
        [menuController setRootController:self.partnerNav animated:YES];
       
    }
    else if (button.tag == 107) {

        //更多
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if ([[defaults objectForKey:USER_USERNAME] isEqualToString:@"guanshaobo"]) {
        if ([[defaults objectForKey:USER_USERNAME] isEqualToString:@"guanshaobo"] ||[[defaults objectForKey:USER_USERNAME] isEqualToString:@"hefei"]) {
            [menuController setRootController:self.moreNav animated:YES];
        } else {
            [GlobalConfig alert:ERROR_LOGINFAIL5];
        }


    }
}

//消息方法
- (void) photoViewController:(NSNotification *)noti
{
//    NSDictionary *dic = noti.object;
//    Photo *photo = dic[@"photo"];
//    NSArray *array = dic[@"array"];
//    [self.photoNav pushViewController:[ControllerFactory createPhotoDetailViewControllerWithCurrentPhoto:photo andPicArray:array] animated:YES];
}

- (void) newsListViewController:(NSNotification *)noti
{

}

- (void) activityListViewController:(NSNotification *)noti
{

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

//上海店 北京店 选择
- (IBAction)button_sh:(id)sender {
    
}

- (IBAction)button_bj:(id)sender {
    
}
- (IBAction)logOut:(id)sender {
    [GlobalConfig deleteUserInfo];
    [[ControllerFactory getSingleDDMenuController] setRootController:[[BaseNavigationController alloc] initWithRootViewController:[ControllerFactory loginInViewController]] animated:YES];
}
@end
