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

static CGFloat activityHeight = 160;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"poseCell";

static NSDictionary *resDic;

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
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_POS];
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    //    [self createSearchBar];
    [self addHeaderView];
    [self downloadData];
    [self showLoadingView];
    
    [self addEGORefreshOnTableView:self.baseTableView];
    resDic = [NSDictionary dictionary];
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
    [[HTTPClient shareHTTPClient] posEvent:nil success:^(NSDictionary *dictionary){
                                        resDic = dictionary;

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
    PosModel *act = self.dataArray[indexPath.row];
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
    PosModel *act = self.dataArray[indexPath.row];
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
    totalLabel.text = [NSString stringWithFormat:@"总%@：%@",lable.text,[self countTotal:0]];
    return view;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
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
    return self.dataArray.count;
}

-(NSString *) countTotal:(int )key {

    int total = 0;
    switch (key) {
        case 0:
            for (PosModel *pos in self.dataArray) {
                total += [pos.o_money intValue];
            }
            break;
        case 1:
            for (PosModel *pos in self.dataArray) {
                total += [pos.t_count intValue];
            }
            break;
        case 2:
            for (PosModel *pos in self.dataArray) {
                total += [pos.succ intValue];
            }
            break;
        case 3:
            for (PosModel *pos in self.dataArray) {
                total += [pos.c intValue];
            }
            break;
        case 4:
            for (PosModel *pos in self.dataArray) {
                total += [pos.a intValue];
            }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%d",total];

}

@end
