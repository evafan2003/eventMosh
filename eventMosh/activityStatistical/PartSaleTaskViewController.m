//
//  PartSaleTaskViewController.m
//  moshTickets
//
//  Created by 魔时网 on 14-5-16.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "PartSaleTaskViewController.h"
#import "PartTaskModel.h"
#import "PartCell.h"
//#import <Frontia/Frontia.h>
//#import "ShareMethod.h"
#import "HTTPClient+PartTask.h"

static CGFloat headerHeight = 10;

@interface PartSaleTaskViewController ()
{
    Activity *_act;
}
@end

@implementation PartSaleTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithActivity:(Activity *)act dataArray:(NSMutableArray *)array
{
    if (self = [super init]) {
        _act = act;
        self.dataArray = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellHeight = 159;
    self.alertView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    [self addHeaderView];
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemAdd title:NAVTITLE_PARTTASK];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(addNewTask)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{UITextAttributeTextColor:WHITECOLOR} forState:UIControlStateNormal];
    
    if (![GlobalConfig isKindOfNSArrayClassAndCountGreaterThanZero:self.dataArray]) {

        self.alertView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addHeaderView
{
    self.baseTableView.tableHeaderView = [GlobalConfig createViewWithFrame:CGRectMake(POINT_X, POINT_Y, SCREENWIDTH, headerHeight)];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"partCell";
    PartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PartCell class]) owner:self options:nil] objectAtIndex:0];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = CLEARCOLOR;
        cell.contentView.backgroundColor = CLEARCOLOR;
        cell.delegate = self;
    }
    PartTaskModel *model = self.dataArray[indexPath.row];
    [cell setValueForCell:model];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (void) navAddClick
{
    [self createAlertView];
}

- (void) createAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加分销任务" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入分销名称"];
    alert.delegate = self;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 ) {
        
        UITextField *field = [alertView textFieldAtIndex:0];
        if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:field.text]) {
            [self showLoadingView];
            [[HTTPClient shareHTTPClient] addNewTaskWithTaskName:field.text
                                                             eid:_act.eid
                                                             uid:_act.uid
                                                         success:^(id jsonData) {
                 [self hideLoadingView];
                 if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
                     NSArray *array = [GlobalConfig convertToArray:jsonData[@"task"]];
                     NSMutableArray *resArray = [NSMutableArray array];
                     for (NSDictionary *dic in array) {
                         PartTaskModel *res = [PartTaskModel partTaskModel:dic currency:_act.currency];
                         [resArray addObject:res];
                     }
                     if (resArray.count > 0) {
                         self.dataArray = resArray;
                         [self.baseTableView reloadData];
                         self.alertView.hidden = YES;
                         [self.baseTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                     }
                     else {
                         [GlobalConfig alert:@"创建失败，请重新创建"];
                     }
                     
                 }
                 else {
                     [GlobalConfig alert:@"创建失败，请重新创建"];
                 }
             }];
        }
        else {
            [GlobalConfig alert:@"名称不能为空，请重新创建任务"];
        }
    }
}

#pragma mark partCellDelegate
- (void) shareWithCell:(PartCell *)cell
{
//    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
//    PartTaskModel *resource = (PartTaskModel *)self.dataArray[indexPath.row];
//    
//    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
//    content.url = resource.url;
//    content.title = _act.title;
//    content.description = [NSString stringWithFormat:@"刚刚发现一个不错的活动，赶快来报名参加吧：“%@”",_act.title];
//    content.imageObj = _act.imageUrl;
//    
//    [ShareMethod shareWithContent:content];
    
}


@end
