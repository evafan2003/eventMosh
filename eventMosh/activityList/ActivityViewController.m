//
//  ActivityViewController.m
//  moshTickets
//
//  Created by 魔时网 on 13-11-18.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "ActivityViewController.h"
#import "ControllerFactory.h"
//#import "NotificationDate.h"
//#import "MOSHLocalNotification.h"
//#import "Reachability.h"
#import "WebViewController.h"   

static CGFloat activityHeight = 150;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";



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
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_ACTIVITYLIST];
//    [self createSearchBar];
    [self addHeaderView];
    [self downloadData];
    [self showLoadingView];
    
//    self.dataArray = (NSMutableArray *)@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
    [self addEGORefreshOnTableView:self.baseTableView];
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
//     Activity *act = self.dataArray[indexPath.row];
//    UIViewController *ctl = [ControllerFactory actDetailControllerWithActivity:act];
//    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(ActivityCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Activity *act = self.dataArray[indexPath.row];

    cell.activityTitle.text = act.title;
    cell.activityDate.text = [NSString stringWithFormat:@"%@ - %@",[GlobalConfig dateFormater:act.start_date format:DATEFORMAT_03],[GlobalConfig dateFormater:act.end_date format:DATEFORMAT_03]];

}

#pragma mark AcitivityCellDelegate
//数据统计
- (void) checkStatisticalWithCell:(ActivityCell *)cell
{
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    //查看统计 act.eid
//    [self.navigationController pushViewController:[ControllerFactory activityStatisticalWithActivity:act] animated:YES];
}

//活动验票
- (void) checkTicketWithCell:(ActivityCell *)cell
{
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    //验票 act.eid
//    [self.navigationController pushViewController:[ControllerFactory ticketConfigViewControllerWithActivity:act] animated:YES];
    
}

//报名信息
- (void) memberInfoWithCell:(ActivityCell *)cell
{
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    
    // act.eid
//    [self.navigationController pushViewController:[ControllerFactory memberStatisticViewControllerWithActivity:act] animated:YES];
}


@end
