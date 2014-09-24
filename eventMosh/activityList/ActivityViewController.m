//
//  ActivityViewController.m
//  moshTickets
//
//  Created by 魔时网 on 13-11-18.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "ActivityViewController.h"
#import "ControllerFactory.h"
#import "WebViewController.h"   


static CGFloat activityHeight = 150;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";
static UIButton *menuButton;


@interface ActivityViewController ()

@end

@implementation ActivityViewController

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
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_ACTIVITYLIST];
    self.navigationItem.hidesBackButton = YES;

//    [self createSearchBar];
//    [self addHeaderView];

    //检查用户权限先
    [self checkPermission];

    
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    [self addEGORefreshOnTableView:self.baseTableView];
    
    [self setMenuButton];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark self.action

- (void) addHeaderView
{
    self.baseTableView.tableHeaderView = [GlobalConfig createViewWithFrame:CGRectMake(POINT_X, POINT_Y, SCREENWIDTH, headerHeight)];
}


- (void) downloadData
{
    [[HTTPClient shareHTTPClient] eventListWithPage:self.page success:^(NSMutableArray *array) {
        [self hideLoadingView];
       [self listFinishWithDataArray:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ActivityCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    //赋值
    [self addDataToCell:cell indexPath:indexPath];
    
    //加载更多
    [self downloadMore:indexPath textColor:BLACKCOLOR];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activity *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory webViewControllerWithTitle:NAVTITLE_ORDERDETAIL Url:[NSString stringWithFormat:@"http://e.mosh.cn/%@",act.eid]];
    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(ActivityCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Activity *act = self.dataArray[indexPath.row];

    cell.activityTitle.text = act.title;
    cell.activityDate.text = [NSString stringWithFormat:@"%@ - %@",[GlobalConfig dateFormater:act.start_date format:DATEFORMAT_03],[GlobalConfig dateFormater:act.end_date format:DATEFORMAT_03]];
    cell.contact.text = [NSString stringWithFormat:@"联系人：%@",act.issue_name];
    cell.sell_ticket_num.text = [NSString stringWithFormat:@"成功订单：%@",act.sell_order_num];
    cell.sell_ticket_money.text = [NSString stringWithFormat:@"票款：%@",act.sell_ticket_money];
    cell.status.text = [self setStatus:act.status];
    cell.is_allpay.text = [self setIsAllpay:act.is_allpay];
    cell.ticket_status.text = [self setSellStatus:act.sell_status];
}

- (void) navListClick
{
    [[ControllerFactory getSingleDDMenuController] showLeftController:YES];
}

- (void) navRefreshClick
{
    ActivitySearchController *vc = [[ActivitySearchController alloc] initWithNibName:@"ActivitySearchController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void) searchFinish:(NSDictionary *)theDic {
    
    
}

//检查权限
-(void) checkPermission {
    
    NSDictionary *arr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PERMISSION];

    //313代表活动管理
    if (arr[@"313"]) {
        
        if ([arr[@"313"] intValue]==31) {
            
            [self showLoadingView];
            [self downloadData];
        } else {
            [GlobalConfig showAlertViewWithMessage:ERROR_NO_PERMISSION superView:nil];
        }
    }
    
}

@end
