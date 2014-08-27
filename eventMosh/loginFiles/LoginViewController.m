//
//  LoginViewController.m
//  moshTicket
//
//  Created by 魔时网 on 13-11-12.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "LoginViewController.h"
#import "ControllerFactory.h"

static NSInteger autoTimer = 60;

@interface LoginViewController ()
{
    NSTimer *_checkNumberTimer;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建导航按钮
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_LOGIN];
    self.backScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    [GlobalConfig textFieldAddLeftView:self.checkNumber];
    [self setUserInfo];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidDisapper:) name:UIKeyboardDidHideNotification object:nil];
    
     UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.backScrollView addGestureRecognizer:tapGesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUserInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:USER_USERNAME];
//    NSString *password = [user objectForKey:USER_PASSWORD];
    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:userName]){
        self.userName.text = userName;
//        self.password.text = password;
    }
}

- (IBAction)login:(id)sender {
    
//    //直接进入
//    [self.navigationController pushViewController:[ControllerFactory controllerWithLoginSuccess] animated:YES];
//    return;
    
    
    if (![self loginCheck]) {
        return;
    }

    [self showLoadingView];
    [[HTTPClient shareHTTPClient] loginWithUserName:self.userName.text
                                           password:self.password.text
                                            success:^(id json){
                                                [self hideLoadingView];
                                                
                                                [self requestSuccess:json];
                                               
    }
                                               fail:^{
                                                   
                                                   [self hideLoadingView];
                                                   [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
    }];
}

- (IBAction)forgetPassword:(id)sender {
    
    [self.navigationController pushViewController:[ControllerFactory controllerWithForgetPassWord] animated:YES];
//    [GlobalConfig push:YES viewController:[ControllerFactory controllerWithForgetPassWord] withNavigationCotroller:self.navigationController animationType:ANIMATIONTYPE_PUSH subType:ANIMATIONSUBTYPE_PUSH Duration:DURATION];
}

- (IBAction)urlButtonPress:(id)sender {
//    @"http://e.mosh.cn/23024"
    [self.navigationController pushViewController:[ControllerFactory webViewControllerWithTitle:NAVTITLE_ACTIVITYLIST Url:@"http://www.evente.cn"] animated:YES];
}

- (IBAction)checkButtonPress:(id)sender {
    if (![self loginCheck]) {
        return;
    }
    [self showLoadingView];
//    [[HTTPClient shareHTTPClient] checkNumberWithUserName:self.userName.text
//                                                 password:self.password.text
//                                                  success:^(id json){
//                                                      [self hideLoadingView];
//                                                      [self getCheckNumberSuccess:json];
//                                                  }
//                                                     fail:^{
//                                                         [self hideLoadingView];
//                                                         [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
//                                                         [self getCheckNUmberFail];
//                                                     }];
}

- (void) requestSuccess:(id)json
{
    if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:json]) {
//        NSString *uid = json[JSONKEY];
        NSNumber *feedback = json[@"status"];
        NSString *alert = json[@"msg"];
        if ([feedback isEqualToNumber:@1]) {
            //保存用户信息
            [GlobalConfig saveUserInfoWithUid:nil
                                     userName:self.userName.text
                                     passWord:self.password.text
                                        phone:nil
                                        email:nil
                                         city:nil
                                       gender:nil
                                        image:nil
                                      binding:nil];
            [GlobalConfig saveObject:@YES withKey:USERDEFULT_LOGIN];
            //登录成功 进入下一个controller
            [self.navigationController pushViewController:[ControllerFactory controllerWithLoginSuccess] animated:YES];
        }
        else if ([feedback isEqualToNumber:@0] && alert.length > 0) {
            [GlobalConfig alert:alert];
        }
        else {
            [GlobalConfig alert:ERROR_LOGINFAIL];
        }
    }
}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.checkNumber resignFirstResponder];
}

- (void) getCheckNumberSuccess:(id)json
{
    if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:json]) {
        NSNumber *feedback = [GlobalConfig convertToNumber:json[JSONFEEDBACK]];
        NSString *res = [GlobalConfig convertToString:json[JSONKEY_RES]];
        if ([feedback isEqualToNumber:@1] && res.length > 0) {
            [GlobalConfig alert:res];
            [self checkNumberStartTimer];
        }
        else if ([feedback isEqualToNumber:@0] && res.length > 0) {
            [GlobalConfig alert:res];
        }
        else {
//            [GlobalConfig alert:ALERT_GETFAIL];
        }
    }
    else {
//        [GlobalConfig alert:ALERT_GETFAIL];
    }
}

- (void) getCheckNUmberFail
{
    
}

- (BOOL) loginCheck
{
    if (![GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:self.userName.text Alert:ERROR_USERNAME]) {
        return NO;
    }
    if (![GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:self.password.text Alert:ERROR_PASSWORD]) {
        return NO;
    }
    return YES;
}

//设置重新获取按钮有效或无效
- (void) getCheckNUmberValid:(BOOL)valid
{
    if (!valid) {
        //    开始倒计时
//        [GlobalConfig alert:ALERT_CHECKNUMBER];
//        autoTimer = 10;
        self.checkButton.enabled = NO;
        [self.checkButton setBackgroundColor:TEXTGRAYCOLOR];
        
    }
    else {
        self.checkButton.enabled = YES;
//        [self.checkButton setBackgroundColor:LOGIN_BLUECOLOR];
    }
}

- (void) checkNumberStartTimer
{
    _checkNumberTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkViewTimerLabelAutoChange) userInfo:nil repeats:YES];
}

//自动倒计时是否可获取验证码
- (void) checkViewTimerLabelAutoChange
{
    if (autoTimer > 0) {
        if (self.checkButton.enabled) {
            [self getCheckNUmberValid:NO];
        }
        NSString *time = [NSString stringWithFormat:@"重新获取(%d)",autoTimer];
        self.checkButton.titleLabel.text = time;
        self.checkButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        autoTimer--;
    }
    else {
        [self.checkButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        [self getCheckNUmberValid:YES];
        autoTimer = 60;
        
        [_checkNumberTimer invalidate];
        
    }
}


#pragma mark uitextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
//    [GlobalConfig textFieldReturnKeyWithArray:@[self.userName,self.password,self.checkNumber]
//                                fistResponder:textField
//                                  andEndBlock:^{
//                                    [self login:nil];
//    }];
    return YES;
}

#pragma mark - UIKeyboardNotification -
- (void) keyBoardDidShow:(NSNotification *)noti
{
    [GlobalConfig keyBoardDidShow:noti scrollView:self.backScrollView];
}

- (void) keyBoardDidDisapper:(NSNotification *)noti
{
    [GlobalConfig keyBoardDidDisapper:noti scrollView:self.backScrollView];
}

@end
