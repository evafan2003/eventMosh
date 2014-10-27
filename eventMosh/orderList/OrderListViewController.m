//
//  OrderListViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "OrderListViewController.h"
#import "Order.h"

static CGFloat activityHeight = 160;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";
static NSString *searchString = @"";
static int perNum = 0;

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

- (void) viewWillAppear:(BOOL)animated
{
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemRefresh title:NAVTITLE_ORDERLIST];
    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    //    [self createSearchBar];
//    [self addHeaderView];
    [self downloadData];
    [self showLoadingView];
    
    [self addEGORefreshOnTableView:self.baseTableView];
    
    //设置菜单按钮
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
    [[HTTPClient shareHTTPClient] orderWithPage:self.page
                                         search:searchString
                                        success:^(NSMutableArray *array){
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
    
    //赋值
    [self addDataToCell:cell indexPath:indexPath];
    //加载更多
    [self downloadMore:indexPath textColor:BLACKCOLOR];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Order *order = self.dataArray[indexPath.row];
//    UIViewController *ctl = [ControllerFactory draftDetailControllerWithDraft:act];
    NSLog(@"%@",[NSString stringWithFormat:@"http://e.mosh.cn/%@",order.eid]);
    UIViewController *ctl = [ControllerFactory webViewControllerWithTitle:NAVTITLE_ORDERDETAIL Url:[NSString stringWithFormat:@"http://e.mosh.cn/%@",order.eid] showToolBar:YES act:order.e_title];
    [self.navigationController pushViewController:ctl animated:YES];
}


//对cell内容赋值
- (void) addDataToCell:(OrderCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Order *order = self.dataArray[indexPath.row];
    
    if ([order.order_state intValue] == 2) {
        cell.not_Pay.hidden = NO;
    }
    
    cell.orderTitle.text = order.e_title;
    cell.orderDate.text = [GlobalConfig dateFormater:order.order_date format:DATEFORMAT_02];
    cell.from.text = order.browser_type;
    cell.payMethod.text = [NSString stringWithFormat:@"支付方式:%@",order.order_way];
    cell.status.text = [NSString stringWithFormat:@"订单状态:%@",[self getStatus:order.order_state]];
    cell.totalPrice.text = [NSString stringWithFormat:@"票款:%@",order.o_money];
    cell.orderUser.text = [NSString stringWithFormat:@"购票用户:%@",order.user_name];
    cell.orderTel.text = [NSString stringWithFormat:@"联系电话:%@",order.tel];
    
}

-(NSString *) getStatus:(NSString *)theStatus {
    switch ([theStatus intValue]) {
        case 1:
            return @"已付款";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return @"已取消";
            break;
        case 4:
            return @"已退订单";
            break;
        default:
            return @"";
            break;
    }
    
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
    searchString = [NSString stringWithFormat:@"&o_id=%@&title=%@",theDic[@"id"],theDic[@"title"]];
    self.page = 1;
    [self downloadData];
}


//检查权限
-(void) checkPermission {
    
    NSDictionary *arr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PERMISSION];
    
    //313代表活动管理
    if (arr[@"324"]) {
        perNum = [arr[@"324"] intValue];
        
        if (perNum>0) {
            
            [self showLoadingView];
            [self downloadData];
        } else {
            [GlobalConfig showAlertViewWithMessage:ERROR_NO_PERMISSION superView:nil];
        }
    }
    
}
@end
