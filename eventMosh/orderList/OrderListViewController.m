//
//  OrderListViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "OrderListViewController.h"

static CGFloat activityHeight = 150;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_DRAFTLIST];
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
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
    [[HTTPClient shareHTTPClient] orderWithPage:self.page search:nil success:^(NSMutableArray *array){
                               [self listFinishWithDataArray:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    //背景
    //    [self changeBackgroundColorForCell:cell indexPath:indexPath];
    
    //赋值
    //    [self addDataToCell:cell indexPath:indexPath];
    
    //加载更多
    //    [self downloadMore:indexPath textColor:BLACKCOLOR];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Draft *act = self.dataArray[indexPath.row];
//    UIViewController *ctl = [ControllerFactory draftDetailControllerWithDraft:act];
    UIViewController *ctl = [ControllerFactory webViewControllerWithTitle:NAVTITLE_ORDERDETAIL Url:@"http://e.mosh.cn/20940"];
    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(Draft *)cell indexPath:(NSIndexPath *)indexPath
{
    //    Activity *act = self.dataArray[indexPath.row];
    //
    //    cell.activityTitle.text = act.title;
    //    cell.activityDate.text = [NSString stringWithFormat:@"%@ - %@",[GlobalConfig dateFormater:act.startDate format:DATEFORMAT_03],[GlobalConfig dateFormater:act.endDate format:DATEFORMAT_03]];
    //    cell.activityAddress.text = act.address;
    
}
@end
