//
//  ActivityOrderViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ActivityOrderViewController.h"
#import "PoseCell.h"
#import "PosModel.h"

static CGFloat activityHeight = 145;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"draftCell";

@interface ActivityOrderViewController ()

@end

@implementation ActivityOrderViewController

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
    [self downloadData];
    [self showLoadingView];
    
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


//下载数据
- (void) downloadData
{
    [[HTTPClient shareHTTPClient] posEvent:nil success:^(NSDictionary *array){
//                                          [self listFinishWithDataArray:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PoseCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    //背景
    //    [self changeBackgroundColorForCell:cell indexPath:indexPath];
    
    //赋值
    [self addDataToCell:cell indexPath:indexPath];
    
    //加载更多
    [self downloadMore:indexPath textColor:BLACKCOLOR];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Faq *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory faqDetailControllerWithFaq:act];
    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(PoseCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Faq *act = self.dataArray[indexPath.row];
    cell.title.text = act.content;
    cell.sold_num.text = act.username;
    cell.sold_price.text = [GlobalConfig dateFormater:act.sug_date format:DATEFORMAT_01];
    cell.succ_order.text = act.email;
    cell.order.text = act.sug_class;
    cell.views.text = act.sug_class;
    cell.pub.text = act.sug_class;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    switch (section) {
        case 0:
            lable.text  = @"售票额";
            break;
        case 1:
            lable.text  = @"售票数";
            break;
        case 2:
            lable.text  = @"成功订单数";
            break;
        case 3:
            lable.text  = @"订单数";
            break;
        case 4:
            lable.text  = @"点击数";
            break;
        default:
            break;
    }
    return view;
    
}

@end
