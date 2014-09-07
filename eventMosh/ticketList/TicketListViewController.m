//
//  TicketListViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "TicketListViewController.h"
#import "TicketCell.h"
#import "Ticket.h"

static CGFloat activityHeight = 155;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";

static NSString *search_addon = @"";

@interface TicketListViewController ()

@end

@implementation TicketListViewController

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
    [[HTTPClient shareHTTPClient] ticketWithPage:self.page search:search_addon success:^(NSMutableArray *array){
                                                        [self listFinishWithDataArray:array];
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TicketCell class]) owner:self options:nil][0];
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
    Ticket *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory ticketDetailControllerWithTicket:act];
    [self.navigationController pushViewController:ctl animated:YES];
}

//对cell内容赋值
- (void) addDataToCell:(TicketCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Ticket *theTic = self.dataArray[indexPath.row];
    
    cell.title.text = theTic.ticket_name;
    cell.date.text = [NSString stringWithFormat:@"%@ - %@",[GlobalConfig dateFormater:theTic.start_date format:DATEFORMAT_03],[GlobalConfig dateFormater:theTic.end_date format:DATEFORMAT_03]];
    cell.sold.text = [NSString stringWithFormat:@"已售：%@",theTic.cou_num];
    cell.remain.text = [NSString stringWithFormat:@"剩余：%@",theTic.sur_num];
    cell.price.text = [NSString stringWithFormat:@"票款：%@",theTic.price];
    cell.event_name.text = [NSString stringWithFormat:@"活动：%@",theTic.event_title];
    cell.status.text = [NSString stringWithFormat:@"状态：%@",[self getStatus:theTic.status]];
    
}

-(NSString *) getStatus:(NSString *)theStatus {
    switch ([theStatus intValue]) {
        case 1:
            return @"未开始和售票中";
            break;
        case 2:
            return @"删除和已结束";
            break;
        case 3:
            return @"暂停";
            break;
        default:
            return @"";
            break;
    }
    
}

@end
