//
//  FaqDetailViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "FaqDetailViewController.h"
#import "FaqCell.h"

static NSString *holder = @"填写回复内容...";
static NSMutableDictionary *postDic;
static Faq *theFaq;


@interface FaqDetailViewController ()

@end

@implementation FaqDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil faq:(Faq *)faq {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        theFaq = faq;
        //        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://e.mosh.cn/%@",_act.eid]];
        self.title = NAVTITLE_FAQDETAIL;
    }
    return self;
}

- (IBAction)sendSite:(id)sender {
    if (self.checkSite.hidden) {
        self.checkSite.hidden = NO;
    } else {
        self.checkSite.hidden = YES;
    }
}

//发送反馈
- (IBAction)save:(id)sender {
    [self setPostValue];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_FAQDETAIL];
    
    if (theFaq) {
        
        [self showLoadingView];
        [self downloadData];
        
    } else {
        
    }

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
    
    postDic = [NSMutableDictionary dictionary];
    if (self.checkSite.hidden && self.mailField.text.length==0) {
        [GlobalConfig alert:@"请选择一种回复方式"];
        return;
    }
    
    //站内信
    if (!self.checkSite.hidden) {
        [postDic setValue:@"y" forKey:@"is_notice"];

    } else {
        [postDic setValue:@"n" forKey:@"is_notice"];
    }
    //邮件
    if (self.mailField.text.length>1) {
        if (![GlobalConfig isValidateEmail:self.mailField.text]) {
            [GlobalConfig alert:@"邮箱格式不正确"];
            return;
        }
        [postDic setValue:@"y" forKey:@"is_email"];
        [postDic setValue:self.mailField.text forKey:@"reply_email"];
    }
    
    if (self.reply.text.length==0) {
        [GlobalConfig alert:@"请填写回复内容"];
        return;
    }
    [postDic setValue:[GlobalConfig getObjectWithKey:USER_USERID] forKey:@"admin_id"];
    [postDic setValue:theFaq.sid forKey:@"sid"];
    [postDic setValue:self.reply.text forKey:@"reply_content"];
    
    [[HTTPClient shareHTTPClient] replyFaq:theFaq.sid dic:postDic sucess:^(id json){

        [self hideLoadingView];
        [[NSNotificationCenter defaultCenter] postNotificationName:FAQ_NOTI object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^{
        [self hideLoadingView];
        [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
    }];
}

//对cell内容赋值
- (void) addDataToCell
{
    FaqCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FaqCell class]) owner:self options:nil][0];
    cell.frame = CGRectMake(0, 0, 320, 150);
    
    cell.faqTitle.text = theFaq.content;
    cell.name.text = theFaq.username;
    cell.faqtime.text = [GlobalConfig dateFormater:theFaq.sug_date format:DATEFORMAT_02];
    cell.email.text = theFaq.email;
    cell.type.text = theFaq.sug_class;
    
    if ([theFaq.is_reply isEqualToString:@"y"]) {
        self.showView.hidden = NO;
        [self.showView addSubview:cell];
        self.replyDate.text = [NSString stringWithFormat:@"回复时间：%@",[GlobalConfig dateFormater:theFaq.reply_date format:DATEFORMAT_02]];
        self.replyMail.text = [NSString stringWithFormat:@"回复方式：%@",theFaq.reply_email.length>1?theFaq.reply_email:@"站内信"];
        self.replyContent.text = [NSString stringWithFormat:@"回复内容：%@",theFaq.reply_content];

        CGRect rect = self.replyContent.frame;
        rect.size = [GlobalConfig getAdjustHeightOfContent:self.replyContent.text width:280 fontSize:14];
        self.replyContent.frame = rect;

        
    } else {
        self.replyView.hidden = NO;
        [self.replyView addSubview:cell];
    }

    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.reply.text isEqualToString:holder]) {
        self.reply.text = @"";
    }
}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
{
    [self.reply resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.reply resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void) keyBoardShow:(NSNotification *)noti
{
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


//下载数据
- (void) downloadData
{
    [[HTTPClient shareHTTPClient] faqWithId:theFaq.sid
                                    success:^(NSDictionary *dic){
                                        theFaq = [[Faq alloc] initWithDictionary:dic];
                                        [self hideLoadingView];
                                        [self addDataToCell];
                                      }];
}

@end
