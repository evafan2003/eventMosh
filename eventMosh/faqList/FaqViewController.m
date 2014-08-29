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
    [[HTTPClient shareHTTPClient] faqWithPage:self.page search:nil
                                      success:^(NSMutableArray *array){
                                          [self listFinishWithDataArray:array];
                                      }];
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
- (void) addDataToCell:(FaqCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Faq *act = self.dataArray[indexPath.row];
    cell.faqTitle.text = act.content;
    cell.name.text = act.username;
    cell.faqtime.text = [GlobalConfig dateFormater:act.sug_date format:DATEFORMAT_01];
    cell.email.text = act.email;
    cell.type.text = act.sug_class;
    
}

@end
