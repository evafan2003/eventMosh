//
//  DraftDetailViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "DraftDetailViewController.h"
#import "DraftCell.h"

@interface DraftDetailViewController ()

@end

static Draft *draft;
static NSMutableDictionary *postDic;
static NSString *teamId = @"";
static NSString *sayNO = @"请填写审核不通过理由";

@implementation DraftDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil draft:(Draft *)act
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        draft = act;
//        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://e.mosh.cn/%@",_act.eid]];
        self.title = NAVTITLE_FAQDETAIL;
    }
    return self;
}

//保存修改
- (IBAction)save:(id)sender {

    //没选择分组的话....
    if (teamId.length == 0) {
        [GlobalConfig showAlertViewWithMessage:@"请选择组" superView:self.view];
        return;
    }

    //审核通过否...
    if (self.theSwitch.on) {
        
//        sayNO = @"";
        
    } else {
        //不通过直接退出...
//        sayNO = @"来自app的拒绝";
    }
    
    [self setPostValue];
    
    [[HTTPClient shareHTTPClient] manageEvent:draft.eid dic:postDic success:^(id json){
        [self hideLoadingView];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^{
        
        [self hideLoadingView];
        [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择类型
- (IBAction)changeType:(id)sender {
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NAVTITLE_DRAFTDETAIL delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"音乐组",@"非音乐组",@"运营组", nil];
    [as showInView:self.view];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DraftCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DraftCell class]) owner:self options:nil][1];
    cell.frame = CGRectMake(0, 0, 320, 175);
    [self.view addSubview:cell];
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemDelete title:NAVTITLE_DRAFTDETAIL];
    if (draft) {
        [self addDataToCell:cell];
    }
    
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


#pragma mark
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.type.text = @"指派给 - 音乐组";
            teamId = @"音乐组";
            break;
        case 1:
            self.type.text = @"指派给 - 非音乐组";
            teamId = @"非音乐组";
            break;
        case 2:
            self.type.text = @"指派给 - 运营组";
            teamId = @"运营组";
            break;
        default:
            self.type.text = @"指派给 - 请选择";
            teamId = @"";
            break;
    }
}


- (void) addDataToCell:(DraftCell *)cell
{
    cell.draftTitle.text = draft.title;
    cell.draftDate.text = [GlobalConfig dateFormater:draft.creation_date format:DATEFORMAT_01];
    cell.user_name.text = [NSString stringWithFormat:@"用户名：%@",draft.mosh_user];
    cell.publisher.text = draft.issue_name;
    cell.company.text = draft.orgname;
    cell.type.text = draft.class_name;
    cell.status.text = [self setStatus:draft.status];
}

//删除按钮
- (void) navDeleteClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入分销名称"];
    alert.delegate = self;
    [alert show];
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 ) {
        //删除
        [[HTTPClient shareHTTPClient] deleteEvent:draft.eid success:^(id json){
            [self hideLoadingView];
            [self.navigationController popViewControllerAnimated:YES];
            
        } fail:^{
            
            [self hideLoadingView];
            [GlobalConfig showAlertViewWithMessage:ERROR superView:self.view];
        }];
        
    }
}

//组装一些post用的值.....
-(void) setPostValue {
    
    postDic = [NSMutableDictionary dictionary];
    [postDic setValue:draft.eid forKey:@"eid"];
    [postDic setValue:teamId forKey:@"e_team"];
    [postDic setValue:@"default" forKey:@"rate"];
    [postDic setValue:self.textView.text forKey:@"explain"];
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:sayNO]) {
        textView.text = @"";
    }
}

- (void)touchesBegan:(UITapGestureRecognizer *)gesture
{
    [self.textView resignFirstResponder];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];        
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
    [UIView animateWithDuration:0.4 animations:^(){
        self.view.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    }];
}
@end
