//
//  ActivityOrderViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ActivityOrderViewController.h"
#import "PoseCell.h"
//#import "PosModel.h"
#import "Activity.h"

static CGFloat activityHeight = 160;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"poseCell";


static NSString *pos_by_month = @"&type=1&";
static NSString *pos_by_week = @"&type=2&";
static NSString *pos_by_day = @"&type=3&";
static NSString *pos_by_all = @"&type=4&";

static NSString *title_by_month = @"活动-日排名";
static NSString *title_by_week = @"活动-日排名";
static NSString *title_by_day = @"活动-日排名";
static NSString *title_by_all = @"活动-日排名";

static NSString *search = @"&type=3&";

static NSDictionary *resDic;

static NSMutableArray *paydata;
static NSMutableArray *ticketdata;
static NSMutableArray *ordersuccdata;
static NSMutableArray *orderdata;
static NSMutableArray *fromdata;


static CustomTabbar *titleBar;


@interface ActivityOrderViewController ()

@end

@implementation ActivityOrderViewController

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:title_by_all];
    self.baseTableView.frame = CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-44);

    //    [self createSearchBar];
//    [self addHeaderView];
    [self downloadData];
    [self showLoadingView];
    
    [self addEGORefreshOnTableView:self.baseTableView];
    resDic = [NSDictionary dictionary];
    
    titleBar = [[CustomTabbar alloc]initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    titleBar.tabbarType = TabbarTypeTop;
    [titleBar setButtons:@[@"按日",@"按周",@"按月",@"全部"]];
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


//下载数据
- (void) downloadData
{
    [[HTTPClient shareHTTPClient] posEvent:search success:^(NSDictionary *dictionary){
                                        resDic = dictionary;
        
                                        paydata = resDic[@"paydata"];
                                        ticketdata = resDic[@"ticketdata"];
                                        ordersuccdata = resDic[@"ordersuccdata"];
                                        orderdata = resDic[@"orderdata"];
                                        fromdata = resDic[@"fromdata"];

                                        [self listFinishWithDic:dictionary];
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
    //赋值
    [self addDataToCell:cell indexPath:indexPath];
    
    //加载更多
//    [self downloadMore:indexPath textColor:BLACKCOLOR];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            self.dataArray = resDic[@"paydata"];
            break;
        case 1:
            self.dataArray = resDic[@"ticketdata"];
            break;
        case 2:
            self.dataArray = resDic[@"ordersuccdata"];
            break;
        case 3:
            self.dataArray = resDic[@"orderdata"];
            break;
        case 4:
            self.dataArray = resDic[@"fromdata"];
            break;
        default:
            break;
    }
//    PosModel *act = self.dataArray[indexPath.row];
    Activity *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory webViewControllerWithTitle:nil Url:[NSString stringWithFormat:@"http://e.mosh.cn/%@",act.eid]];
    [self.navigationController pushViewController:ctl animated:YES];

}


//对cell内容赋值
- (void) addDataToCell:(PoseCell *)cell indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            self.dataArray = resDic[@"paydata"];
            break;
        case 1:
            self.dataArray = resDic[@"ticketdata"];
            break;
        case 2:
            self.dataArray = resDic[@"ordersuccdata"];
            break;
        case 3:
            self.dataArray = resDic[@"orderdata"];
            break;
        case 4:
            self.dataArray = resDic[@"fromdata"];
            break;
        default:
            break;
    }
//    PosModel *act = self.dataArray[indexPath.row];
    Activity *act = self.dataArray[indexPath.row];
    cell.title.text = act.title;
    cell.sold_num.text = [NSString stringWithFormat:@"售票数：%@",act.t_count];
    cell.sold_price.text = [NSString stringWithFormat:@"售票额：%@%@",act.bz,act.o_money];
    cell.succ_order.text = [NSString stringWithFormat:@"成功订单数：%@",act.succ];
    cell.order.text = [NSString stringWithFormat:@"订单数：%@",act.c];
    cell.views.text = [NSString stringWithFormat:@"点击数：%@",act.a];
    cell.pub.text = [NSString stringWithFormat:@"发布者：%@",act.orgname];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [resDic allKeys].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
    line.backgroundColor = [UIColor grayColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    lable.textColor = [UIColor redColor];
    lable.font = [UIFont systemFontOfSize:14];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 0, 160, 44)];
    totalLabel.textColor = [UIColor redColor];
    totalLabel.font = [UIFont systemFontOfSize:14];
    totalLabel.textAlignment = UITextAlignmentRight;
    
    [view addSubview:totalLabel];
    [view addSubview:line];
    [view addSubview:lable];
    
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
    totalLabel.text = [NSString stringWithFormat:@"总%@：%@",lable.text,[self countTotal:section]];
    return view;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return paydata.count;
            break;
        case 1:
            return ticketdata.count;
            break;
        case 2:
            return ordersuccdata.count;
            break;
        case 3:
            return orderdata.count;
            break;
        case 4:
            return fromdata.count;
            break;
        default:
            break;
    }
    return self.dataArray.count;
}

-(NSString *) countTotal:(int )key {

    int total = 0;
    switch (key) {
        case 0:
            for (Activity *pos in paydata) {
                total += [pos.o_money intValue];
            }
            break;
        case 1:
            for (Activity *pos in ticketdata) {
                total += [pos.t_count intValue];
            }
            break;
        case 2:
            for (Activity *pos in ordersuccdata) {
                total += [pos.succ intValue];
            }
            break;
        case 3:
            for (Activity *pos in orderdata) {
                total += [pos.c intValue];
            }
            break;
        case 4:
            for (Activity *pos in fromdata) {
                total += [pos.a intValue];
            }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%d",total];

}


#pragma mark
#pragma CustomTabbarDelegate

-(void) switchTabBar:(id)sender {
    switch ([sender tag]) {
        case 0:
            //日
            search = pos_by_day;
            break;
        case 1:
            //周
            search = pos_by_week;
            break;
        case 2:
            //月
            search = pos_by_month;
            break;
        case 3:
            //全部
            search = pos_by_all;
            break;
            
        default:
            break;
    }
    [self showLoadingView];
    [self downloadData];
    
}

- (void) navListClick
{
    [[ControllerFactory getSingleDDMenuController] showLeftController:YES];
}

@end
