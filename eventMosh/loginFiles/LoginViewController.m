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
static UIButton *returnButton;

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
    
    self.checkNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    
    returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, SCREENHEIGHT-50, 109, 50);
    [returnButton addTarget:self action:@selector(touchesBegan:) forControlEvents:UIControlEventTouchUpInside];

    [returnButton setTitle:@"完成" forState:UIControlStateNormal];

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
                                          phoneCode:self.checkNumber.text
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
    [self.navigationController pushViewController:[ControllerFactory webViewControllerWithTitle:NAVTITLE_ACTIVITYLIST Url:@"http://www.evente.cn" showToolBar:NO act:nil] animated:YES];
}

//发送验证码
- (IBAction)checkButtonPress:(id)sender {
    if (![self loginCheck]) {
        return;
    }
    
    [self touchesBegan:nil];
    
    [self showLoadingView];
    
    [[HTTPClient shareHTTPClient] sendPhoneCodeWithUserName:self.userName.text
                                                   password:self.password.text
                                                    success:^(id success){
    
        [self hideLoadingView];
        [GlobalConfig alert:success];
        
    } fail:^{
        
        [GlobalConfig alert:ERROR_LOGINFAIL];
        
    }];
}

- (void) requestSuccess:(id)json
{
    if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:json]) {

        NSNumber *feedback = json[@"status"];
        NSString *alert = json[@"msg"];
        
        //暂用权限规则：超级管理员才可登录 gid=1
        /*
         全部的分组(线上)
             超级管理员 1
             地方站管理员 14
             客服人员 17
             北京站运营人员 20
             超级管理员（无删除）44
             市场营销人员 48
             人事行政组 49
             佛学公司组 50
            
         全部的分组(线下)
         
         */
        
        if ([feedback isEqualToNumber:@1]) {
            //保存用户信息
            [GlobalConfig saveUserInfoWithUid:json[@"res"][@"uid"]
                                     userName:self.userName.text
                                     passWord:self.password.text
                                        phone:nil
                                        email:nil
                                         city:nil
                                       gender:nil
                                        image:nil
                                        group:json[@"res"][@"gid"]
                                      binding:nil
                                   permission:json[@"res"][@"permission"]
             ];
            [GlobalConfig saveObject:@YES withKey:USERDEFULT_LOGIN];
            //登录成功 进入下一个controller
            [self.navigationController pushViewController:[ControllerFactory controllerWithLoginSuccess] animated:YES];
            [self touchesBegan:nil];
        }
        else if ([feedback isEqualToNumber:@0] && alert.length > 0) {
            [GlobalConfig alert:alert];
        }
        else {
            [GlobalConfig alert:ERROR_LOGINFAIL5];
        }
    }
}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.checkNumber resignFirstResponder];
    [returnButton removeFromSuperview];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    if ([self.checkNumber isFirstResponder]) {
//        UIWindow *win = [[[UIApplication sharedApplication] windows] lastObject];
//        [win addSubview:returnButton];
//    } else {
//        [returnButton removeFromSuperview];
//    }
}


#pragma mark uitextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.userName) {
        [self.password becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - UIKeyboardNotification -
- (void) keyBoardDidShow:(NSNotification *)noti
{

}

- (void) keyBoardDidDisapper:(NSNotification *)noti
{

}

@end
