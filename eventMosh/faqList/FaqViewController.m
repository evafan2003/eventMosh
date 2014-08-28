//
//  FaqViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "FaqViewController.h"
#import "FaqCell.h"
#import "FaqDetailViewController.h"
#import "Faq.h"

static CGFloat activityHeight = 145;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"draftCell";

@interface FaqViewController ()

@end

@implementation FaqViewController

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
    [self.navigationController.navigationBar setHidden:NO];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_FAQLIST];
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    //    [self createSearchBar];
    [self addHeaderView];
    //    [self downloadData];
    //    [self showLoadingView];
    
    self.dataArray = (NSMutableArray *)@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
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
    //    [[HTTPClient shareHTTPClient] activityListWithPage:self.page
    //                                               success:^(NSMutableArray *array){
    //
    //                                                   [self listFinishWithDataArray:array];
    //                                               }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaqCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FaqCell class]) owner:self options:nil][0];
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
    Faq *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory faqDetailControllerWithFaq:act];
    [self.navigationController pushViewController:ctl animated:YES];
}

//更改cell背景色
- (void) changeBackgroundColorForCell:(FaqCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //    Activity *act = self.dataArray[indexPath.row];
    //
    //    //当前时间大于开始时间
    //    if ([GlobalConfig dateCompareWithCurrentDate:act.startDate] == NSOrderedAscending) {
    //        //大于结束时间 已结束
    //        if ([GlobalConfig dateCompareWithCurrentDate:act.endDate] == NSOrderedAscending) {
    //            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_end]];
    //            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_end]];
    //        }
    //        else {//进行中
    //            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_display]];
    //            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_display]];
    //        }
    //    }
    //    else {//未开始
    //        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_notStart]];
    //        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:act_notStart]];
    //    }
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

#pragma mark AcitivityCellDelegate
//数据统计
- (void) checkStatisticalWithCell:(FaqCell *)cell
{
    //    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    //    Activity *act = self.dataArray[indexPath.row];
    //查看统计 act.eid
    //    [self.navigationController pushViewController:[ControllerFactory activityStatisticalWithActivity:act] animated:YES];
}

//活动验票
- (void) checkTicketWithCell:(FaqCell *)cell
{
    //    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    //    Activity *act = self.dataArray[indexPath.row];
    //验票 act.eid
    //    [self.navigationController pushViewController:[ControllerFactory ticketConfigViewControllerWithActivity:act] animated:YES];
    
}

//报名信息
- (void) memberInfoWithCell:(FaqCell *)cell
{
    //    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    //    Activity *act = self.dataArray[indexPath.row];
    
    // act.eid
    //    [self.navigationController pushViewController:[ControllerFactory memberStatisticViewControllerWithActivity:act] animated:YES];
}


@end
