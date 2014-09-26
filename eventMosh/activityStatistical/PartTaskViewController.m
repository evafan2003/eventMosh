//
//  PartTaskViewController.m
//  moshTickets
//
//  Created by 魔时网 on 14-5-23.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "PartTaskViewController.h"
#import "PartTaskModel.h"
//#import <Frontia/Frontia.h>
//#import "ShareMethod.h"
#import "HTTPClient+PartTask.h"

@interface PartTaskViewController ()

@end

@implementation PartTaskViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(addNewTask)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{UITextAttributeTextColor:WHITECOLOR} forState:UIControlStateNormal];
    self.title = NAVTITLE_PARTTASK;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) listLabelName:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"分销名称";
        case 1:
            return @"到访量";
        case 2:
            return @"成单量";
        case 3:
            return @"销售额";
        default:
            return @"";
            break;
    }
}

- (NSString *) contentOfCellInIndexPath:(NSIndexPath *)indexPath labelIndex:(NSInteger)index
{
    PartTaskModel *resource = (PartTaskModel *)self.dataArray[indexPath.row];
    switch (index) {
        case 0:
            return resource.name;
            break;
        case 1:
            return resource.peppleCount;
            break;
        case 2:
            return resource.successOrder;
            break;
        case 3:
            return resource.totalSales;
            break;
        default:
            return @"";
            break;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PartTaskModel *resource = (PartTaskModel *)self.dataArray[indexPath.row];
//    
//    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
//    content.url = resource.url;
//    content.title = _act.title;
//    content.description = [NSString stringWithFormat:@"刚刚发现一个不错的活动，赶快来报名参加吧：“%@”",_act.title];
//    content.imageObj = _act.imageUrl;
//    
//    [ShareMethod shareWithContent:content];
}

- (void) addNewTask
{
    [self createAlertView];
}

- (void) createAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加分销任务" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入分销名称"];
    alert.delegate = self;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 ) {
        
        UITextField *field = [alertView textFieldAtIndex:0];
        if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:field.text]) {
            self.loadingView.hidden = NO;
            [[HTTPClient shareHTTPClient] addNewTaskWithTaskName:field.text
                                                             eid:_act.eid
                                                             uid:_act.uid
                                                         success:^(id jsonData) {
             self.loadingView.hidden = YES;
             if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
                 NSArray *array = [GlobalConfig convertToArray:jsonData[@"task"]];
                 NSMutableArray *resArray = [NSMutableArray array];
                 for (NSDictionary *dic in array) {
                     PartTaskModel *res = [PartTaskModel partTaskModel:dic currency:_act.currency];
                     [resArray addObject:res];
                 }
                 if (resArray.count > 0) {
                     self.dataArray = resArray;
                     [self.baseTableView reloadData];
                 }
                 else {
                     [GlobalConfig alert:@"创建失败，请重新创建"];
                 }
                 
             }
             else {
                 [GlobalConfig alert:@"创建失败，请重新创建"];
             }
         }];
        }
        else {
            [GlobalConfig alert:@"名称不能为空，请重新创建任务"];
        }
    }
}

@end
