//
//  DraftViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "DraftViewController.h"
static CGFloat activityHeight = 155;
static CGFloat headerHeight = 13;
static NSString *cellIdentifier = @"activityCell";
static NSString *act_end = @"actList_cellBg03";
static NSString *act_display = @"actList_cellBg01";
static NSString *act_notStart = @"actList_cellBg02";
static NSString *searchString = @"";
static int perNum = 0;

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
    [[ControllerFactory getSingleDDMenuController] gestureSetEnable:NO isShowRight:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    self.cellHeight = activityHeight;
    [self createBarWithLeftBarItem:MoshNavigationBarItemNone rightBarItem:MoshNavigationBarItemRefresh title:NAVTITLE_DRAFTLIST];
    //    [self createSearchBar];

    self.baseTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
    
//    [self addHeaderView];
    //检查用户权限先
    [self checkPermission];
    
    [self addEGORefreshOnTableView:self.baseTableView];
    
    
    //设置菜单按钮
    [self setMenuButton];
    
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
                                         search:searchString
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
    //检察权限
    if (perNum >= 16) {

        Draft *act = self.dataArray[indexPath.row];
        UIViewController *ctl = [ControllerFactory draftDetailControllerWithDraft:act];
        [self.navigationController pushViewController:ctl animated:YES];
        
    } else {
        
        [GlobalConfig showAlertViewWithMessage:ERROR_NO_PERMISSION superView:nil];
        
    }

}

//对cell内容赋值
- (void) addDataToCell:(DraftCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Draft *act = self.dataArray[indexPath.row];
    
    cell.draftTitle.text = act.title;
    cell.draftDate.text = [GlobalConfig dateFormater:act.creation_date format:DATEFORMAT_01];
    cell.user_name.text = [NSString stringWithFormat:@"用户名：%@",act.mosh_user];
    cell.publisher.text = [NSString stringWithFormat:@"联系人：%@",act.issue_name];
    cell.company.text = [NSString stringWithFormat:@"主办方：%@",act.orgname];
    cell.type.text = act.class_name;
    cell.status.text = [self setStatus:act.status];
    
    if ([cell.status.text isEqualToString:@"未审核"]) {
        cell.status.textColor = [UIColor redColor];
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
    searchString = [NSString stringWithFormat:@"&eid=%@&title=%@",theDic[@"id"],theDic[@"title"]];
    self.page = 1;
    [self downloadData];
}

//检查权限
-(void) checkPermission {
    
    NSDictionary *arr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PERMISSION];
    
    //313代表活动管理
    if (arr[@"314"]) {
        perNum = [arr[@"314"] intValue];
        
        if (perNum>0) {
            
            [self showLoadingView];
            [self downloadData];
        } else {
            [GlobalConfig showAlertViewWithMessage:ERROR_NO_PERMISSION superView:nil];
        }
    }
    
}
@end
