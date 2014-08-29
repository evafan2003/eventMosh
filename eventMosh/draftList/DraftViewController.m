//
//  DraftViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "DraftViewController.h"
static CGFloat activityHeight = 150;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";

@interface DraftViewController ()

@end

@implementation DraftViewController

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

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_DRAFTLIST];
    //    [self createSearchBar];

    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    
    [self addHeaderView];
    [self downloadData];
    [self showLoadingView];
    
//    self.dataArray = (NSMutableArray *)@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
    [self addEGORefreshOnTableView:self.baseTableView];
    
    //删除的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draftReload) name:DRAFT_NOTI object:nil];
}

-(void) draftReload {
    [self showLoadingView];
    self.page = 1;
    [self downloadData];
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
    [[HTTPClient shareHTTPClient] draftWithPage:self.page
                                         search:nil
                                        success:^(NSMutableArray *array){
                                            
                                            [self listFinishWithDataArray:array];
                                            
                                        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DraftCell class]) owner:self options:nil][0];
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
    Draft *act = self.dataArray[indexPath.row];
    UIViewController *ctl = [ControllerFactory draftDetailControllerWithDraft:act];
    [self.navigationController pushViewController:ctl animated:YES];
}

//更改cell背景色
- (void) changeBackgroundColorForCell:(DraftCell *)cell indexPath:(NSIndexPath *)indexPath
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
- (void) addDataToCell:(DraftCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Draft *act = self.dataArray[indexPath.row];
    
    cell.draftTitle.text = act.title;
    cell.draftDate.text = [GlobalConfig dateFormater:act.creation_date format:DATEFORMAT_01];
    cell.user_name.text = [NSString stringWithFormat:@"用户名：%@",act.mosh_user];
    cell.publisher.text = act.issue_name;
    cell.company.text = act.orgname;
    cell.type.text = act.class_name;
    cell.status.text = [self setStatus:act.status];
}


@end
