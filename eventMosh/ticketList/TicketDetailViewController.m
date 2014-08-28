//
//  TicketDetailViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "TicketDetailViewController.h"

@interface TicketDetailViewController ()

@end

@implementation TicketDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ticket:(Ticket *)ticket
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NAVTITLE_TICKETDETAIL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_TICKETDETAIL];
    
    
    self.t_num.keyboardType = UIKeyboardTypeNumberPad;
    self.t_price.keyboardType = UIKeyboardTypeNumberPad;
    self.original_num.keyboardType = UIKeyboardTypeNumberPad;
    self.order_min_num.keyboardType = UIKeyboardTypeNumberPad;
    self.order_max_num.keyboardType = UIKeyboardTypeNumberPad;

    //触摸手势（收键盘）
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDisapper:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//组装一些post用的值.....
-(void) setPostValue {
    
//    postDic = [NSMutableDictionary dictionary];
//    [postDic setValue:draft.eid forKey:@"eid"];
//    [postDic setValue:teamId forKey:@"e_team"];
//    [postDic setValue:@"default" forKey:@"rate"];
//    [postDic setValue:self.textView.text forKey:@"explain"];
    
}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
{
    for (UIView *textField in [self.view subviews]) {
        
        if ([textField isKindOfClass:[UITextField class] ]) {
            [textField resignFirstResponder];
        }
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.t_name == textField || self.t_price == textField || self.t_num == textField) {

    } else {
        [UIView animateWithDuration:0.3 animations:^(){
            self.view.frame = CGRectMake(0, -40, SCREENWIDTH, SCREENHEIGHT);
        }];
    }
    return YES;
}

//通知处理键盘
- (void) keyBoardShow:(NSNotification *)noti
{
    if ([self.t_name isFirstResponder] || [self.t_price isFirstResponder] || [self.t_num isFirstResponder]) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^(){
        self.view.frame = CGRectMake(0, -40, SCREENWIDTH, SCREENHEIGHT);
    }];
}

- (void) keyBoardDisapper:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^(){
        self.view.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    }];
}

@end
