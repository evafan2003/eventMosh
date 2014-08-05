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

@implementation DraftDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil draft:(Draft *)act
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _act = act;
//        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://e.mosh.cn/%@",_act.eid]];
        self.title = NAVTITLE_FAQDETAIL;
    }
    return self;
}

//保存修改
- (IBAction)save:(id)sender {
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
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_DRAFTDETAIL];
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
            break;
        case 1:
            self.type.text = @"指派给 - 非音乐组";
            break;
        case 2:
            self.type.text = @"指派给 - 运营组";
            break;
        default:
            self.type.text = @"指派给 - 请选择";
            break;
    }
}
@end
