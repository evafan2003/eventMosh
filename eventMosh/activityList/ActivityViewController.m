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


static CGFloat activityHeight = 230;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";
static UIButton *menuButton;

NSString *phone = @"";

NSString *searchString = @"";
NSString *sell_status = @"";

static CustomTabbar *titleBar;

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
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemRefresh title:NAVTITLE_ACTIVITYLIST];
    self.navigationItem.hidesBackButton = YES;

//    [self createSearchBar];
//    [self addHeaderView];

    //检查用户权限先
    [self checkPermission];

    
    self.baseTableView.frame = CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-44);
    [self addEGORefreshOnTableView:self.baseTableView];
    
    
    titleBar = [[CustomTabbar alloc]initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    titleBar.tabbarType = TabbarTypeTop;
    [titleBar setButtons:@[@"售票中",@"未开始",@"已结束"]];
    titleBar.customTabbarDelegate = self;
    [self.view addSubview:titleBar];
    
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
    [[HTTPClient shareHTTPClient] eventListWithPage:self.page
                                             search:[sell_status stringByAppendingString:searchString]
                                            success:^(NSMutableArray *array) {
                                                
//                                                [self hideLoadingView];
                                                [self listFinishWithDataArray:array];
                                                searchString = @"";
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
    UIViewController *ctl = [ControllerFactory webViewControllerWithTitle:NAVTITLE_ACTIVITYDETAIL Url:[NSString stringWithFormat:@"http://e.mosh.cn/%@",act.eid] showToolBar:YES act:act.title];
    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(ActivityCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Activity *act = self.dataArray[indexPath.row];

    cell.activityTitle.text = act.title;
    cell.activityDate.text = [NSString stringWithFormat:@"%@ - %@",[GlobalConfig dateFormater:act.start_date format:DATEFORMAT_03],[GlobalConfig dateFormater:act.end_date format:DATEFORMAT_03]];
    cell.contact.text = [NSString stringWithFormat:@"联系人：%@",act.issue_name];
    cell.sell_order_money.text = [NSString stringWithFormat:@"成功订单：%@",act.sell_order_num];
    cell.sell_ticket_num.text = [NSString stringWithFormat:@"售票数：%@",act.sell_ticket_num];
    cell.sell_ticket_money.text = [NSString stringWithFormat:@"票款：%@",act.sell_ticket_money];
    cell.status.text = [self setStatus:act.status];
    cell.is_allpay.text = [self setIsAllpay:act.is_allpay];
    cell.account.text = [NSString stringWithFormat:@"%@/%@", act.account,act.passwd];
//    cell.ticket_status.text = status;
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
    [self showLoadingView];
    searchString = [sell_status stringByAppendingString:[NSString stringWithFormat:@"&eid=%@&title=%@",theDic[@"id"],theDic[@"title"]]];
    self.page = 1;
    [self downloadData];
    
}

//检查权限
-(void) checkPermission {
    
    NSDictionary *arr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PERMISSION];

    //313代表活动管理
    if (arr[@"313"]) {
        
        if ([arr[@"313"] intValue]==31) {

            searchString = @"&sell_status=1";
            
            [self showLoadingView];
            [self downloadData];
            
        } else {
            [GlobalConfig showAlertViewWithMessage:ERROR_NO_PERMISSION superView:nil];
        }
    }
    
}


-(void) call:(ActivityCell *)cell {
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    //验票 act.eid
    phone = act.issue_tel;
    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:act.issue_tel]) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话：%@？",phone] delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [a show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [GlobalConfig makeCall:phone];
    }
}


#pragma mark AcitivityCellDelegate
//数据统计
- (void) checkStatisticalWithCell:(ActivityCell *)cell
{
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    //查看统计 act.eid
    [self.navigationController pushViewController:[ControllerFactory activityStatisticalWithActivity:act] animated:YES];
}


#pragma mark
#pragma CustomTabbarDelegate

-(void) switchTabBar:(id)sender {
    switch ([sender tag]) {
        case 0:
            //售票中
            sell_status  = @"&sell_status=1";
            break;
        case 1:
            //未开始
            sell_status  = @"&sell_status=2";
            break;
        case 2:
            //已结束
            sell_status  = @"&sell_status=3";
            break;
        default:
            break;
    }
    self.page = 1;
    [self showLoadingView];
    [self downloadData];
    
}
@end
