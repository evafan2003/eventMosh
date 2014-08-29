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

//发送邮件
- (IBAction)sendMail:(id)sender {
    if (self.checkMail.hidden) {
        self.checkMail.hidden = NO;
    } else {
        self.checkMail.hidden = YES;
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FaqCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FaqCell class]) owner:self options:nil][0];
    cell.frame = CGRectMake(0, 0, 320, 150);
    [self.view addSubview:cell];
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_FAQDETAIL];
    
    if (theFaq) {
        [self addDataToCell:cell];
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
//    [postDic setValue:theFaq.eid forKey:@"eid"];
//    [postDic setValue:teamId forKey:@"e_team"];
//    [postDic setValue:@"default" forKey:@"rate"];
//    [postDic setValue:self.reply.text forKey:@"explain"];
    
}

//对cell内容赋值
- (void) addDataToCell:(FaqCell *)cell
{
    cell.faqTitle.text = theFaq.content;
    cell.name.text = theFaq.username;
    cell.faqtime.text = [GlobalConfig dateFormater:theFaq.sug_date format:DATEFORMAT_01];
    cell.email.text = theFaq.email;
    cell.type.text = theFaq.sug_class;
    
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
@end
