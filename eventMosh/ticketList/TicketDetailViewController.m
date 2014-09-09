//
//  TicketDetailViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "Ticket.h"


static NSMutableDictionary *postDic;
static Ticket *theTic;
static WSDatePickerView *picker;
static BOOL start = YES;
@interface TicketDetailViewController ()

@end

@implementation TicketDetailViewController

#pragma mark
#pragma WSDatePickerViewDelegate

- (void)wsdatePickerSelectDate:(NSDate *)date mode:(UIDatePickerMode)mode {
    
    if (start) {

        self.startDateLabel.text = [GlobalConfig date:date format:DATEFORMAT_02];
        theTic.start_date = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
        ;
    } else {
        
        start = YES;
        
        self.endDateLabel.text = [GlobalConfig date:date format:DATEFORMAT_02];
        theTic.end_date = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
        ;
    }


}


- (IBAction)startDatePressed:(id)sender {

//    picker
    picker = [[WSDatePickerView alloc] initWithdataPickerMode:UIDatePickerModeDateAndTime];
    picker.backgroundColor = WHITECOLOR;
    picker.delegate = self;
    
    picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[theTic.start_date intValue]];
    [self.view.window addSubview:picker];

}

- (IBAction)endDatePressed:(id)sender {

    start = NO;
    picker = [[WSDatePickerView alloc] initWithdataPickerMode:UIDatePickerModeDateAndTime];
    picker.backgroundColor = WHITECOLOR;
    picker.delegate = self;
    picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[theTic.end_date intValue]];
    [self.view.window addSubview:picker];
}

- (IBAction)savePressed:(id)sender {
    [self showLoadingView];
    [self setPostValue];
    [[HTTPClient shareHTTPClient] replyTicket:theTic.ticket_id dic:postDic sucess:^(id json){
        [self hideLoadingView];
        //修改的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TICKET_NOTI object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(){
        [self hideLoadingView];
        [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ticket:(Ticket *)ticket
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        theTic = ticket;
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
    
    //设置数据
    self.ticketTitle.text = theTic.event_title;
    self.t_name.text = theTic.ticket_name;
    self.t_price.text = theTic.price;
    self.t_num.text = theTic.sur_num;
    self.original_num.text = theTic.original_price;
    self.order_min_num.text = theTic.lowest_sell;
    self.order_max_num.text = theTic.highest_sell;
    self.startDateLabel.text = [GlobalConfig dateFormater:theTic.start_date format:DATEFORMAT_02];
    self.endDateLabel.text = [GlobalConfig dateFormater:theTic.end_date format:DATEFORMAT_02];
    
    if ([theTic.is_free isEqualToString:@"Y"]) {
        self.isFree.on = YES;
    } else {
        
        self.isFree.on = NO;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//组装一些post用的值.....
-(void) setPostValue {
    
    postDic = [NSMutableDictionary dictionary];
    [postDic setValue:theTic.ticket_id forKey:@"ticket_id"];
    [postDic setValue:theTic.start_date forKey:@"startDate"];
    [postDic setValue:theTic.end_date forKey:@"endDate"];
    [postDic setValue:self.t_num.text forKey:@"ticket_num"];
    [postDic setValue:self.order_min_num.text forKey:@"lowest_sell"];
    [postDic setValue:self.order_max_num.text forKey:@"highest_sell"];
    [postDic setValue:self.t_num.text forKey:@"sur_num"];
    [postDic setValue:self.t_price.text forKey:@"price"];
    [postDic setValue:self.original_num.text forKey:@"original_price"];
    [postDic setValue:self.t_name.text forKey:@"ticket_name"];
    if (self.isFree.on) {
        [postDic setValue:@"Y" forKey:@"is_free"];
    } else {
        [postDic setValue:@"N" forKey:@"is_free"];
    }

}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
{
    [picker removePickerView];
    for (UIView *textField in [self.view subviews]) {
        
        if ([textField isKindOfClass:[UITextField class] ]) {
            [textField resignFirstResponder];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        [picker removePickerView];
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
