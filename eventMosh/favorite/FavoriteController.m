//
//  favoriteController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-9-25.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "favoriteController.h"

#import "Activity.h"
#import "EventDatabase.h"

static CGFloat activityHeight = 160;
static NSString *cellIdentifier = @"poseCell";


static NSString *title_by_month = @"活动-日排名";
static NSString *title_by_week = @"活动-日排名";
static NSString *title_by_day = @"活动-日排名";
static NSString *title_by_all = @"活动-日排名";

static NSString *search = @"&type=3&";


@interface FavoriteController ()

@end

@implementation FavoriteController

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
    [self downloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:title_by_all];
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);

    [self addEmptyViewWithAlertContent:NO_FAVORITE AlertImageName:nil];
    
//    [self addEGORefreshOnTableView:self.baseTableView];
//    resDic = [NSDictionary dictionary];
    
    
    [self setMenuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置Cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAVORITE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if(indexPath.row ==0)
     {
     [tableView setEditing:YES animated:YES];  //这个是整体出现
     }
     */
    return UITableViewCellEditingStyleDelete;
}


//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"touchIIddddd");
    /*
     if(indexPath ==0)
     {
     [tableView setEditing:NO animated:YES];
     }
     */
    Activity *act = self.dataArray[indexPath.row];
    [[EventDatabase sharedInstance] removeFavorite:act.eid];
    [GlobalConfig alert:FAVORITE_REMOVE];
    [tableView setEditing:NO animated:YES];
    [self downloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PoseCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    //赋值
    [self addDataToCell:cell indexPath:indexPath];
    
    return cell;
}

//对cell内容赋值
- (void) addDataToCell:(PoseCell *)cell indexPath:(NSIndexPath *)indexPath
{

    Activity *act = self.dataArray[indexPath.row];
    cell.title.text = act.title;
    cell.sold_num.text = [NSString stringWithFormat:@"售票数：%@",act.t_count];
    cell.sold_price.text = [NSString stringWithFormat:@"售票额：%@%@",act.bz,act.o_money];
    cell.succ_order.text = [NSString stringWithFormat:@"成功订单数：%@",act.succ];
    cell.order.text = [NSString stringWithFormat:@"订单数：%@",act.c];
    cell.views.text = [NSString stringWithFormat:@"点击数：%@",act.a];
    cell.pub.text = [NSString stringWithFormat:@"发布者：%@",act.orgname];
    
}

//下载数据
- (void) downloadData
{
    self.dataArray = [[EventDatabase sharedInstance] getAllFavorite];
    
    if (self.emptyView) {
        if (![GlobalConfig isKindOfNSArrayClassAndCountGreaterThanZero:self.dataArray]) {
            self.baseTableView.hidden = YES;
            self.emptyView.hidden = NO;
        }
        else {
            self.baseTableView.hidden = NO;
            self.emptyView.hidden = YES;
            [self.baseTableView reloadData];
        }
    }

}

- (void) navListClick
{
    [[ControllerFactory getSingleDDMenuController] showLeftController:YES];
}


#pragma mark AcitivityCellDelegate
//数据统计
- (void) checkStatisticalWithCell:(PoseCell *)cell
{
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    Activity *act = self.dataArray[indexPath.row];
    //查看统计 act.eid
    [self.navigationController pushViewController:[ControllerFactory activityStatisticalWithActivity:act] animated:YES];
}

-(void)call:(PoseCell *)cell {
    
}
@end
