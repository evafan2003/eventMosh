//
//  ActivityDetailViewController.m
//  moshTickets
//
//  Created by 魔时网 on 14-6-27.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ActivityDetailViewController.h"
//#import <Frontia/Frontia.h>
//#import "ShareMethod.h"
//#import "HTTPClient+PartTask.h" 
//#import "PartTaskModel.h"   
#import "ControllerFactory.h"


@interface ActivityDetailViewController ()
{
    Activity *_act;
}
@end

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil activity:(Activity *)act
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _act = act;
        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://e.mosh.cn/%@",_act.eid]];
        self.title = @"活动详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.blurView];
    
    CGRect rect = self.webView.frame;
    rect.size.height -= CGRectGetHeight(self.blurView.frame);
    self.webView.frame = rect;
    
//    self.blurView.blurRadius = 0.4;
//    self.blurView.backgroundColor = BLACKCOLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonClick:(id)sender {
    
//    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
//    content.url = [self.URL absoluteString];
//    content.title = _act.title;
//    content.description = [NSString stringWithFormat:@"刚刚发现一个不错的活动，赶快来报名参加吧：“%@”",_act.title];
//    content.imageObj = _act.imageUrl;
//   
//    [ShareMethod shareWithContent:content];
}

- (IBAction)partButtonClick:(id)sender {

        [self showLoadingView];
//        [[HTTPClient shareHTTPClient] addNewTaskWithTaskName:@""
//                                                         eid:_act.eid
//                                                     success:^(id jsonData) {
//            [self hideLoadingView];
//            if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
//                NSArray *array = [GlobalConfig convertToArray:jsonData[@"task"]];
//                NSMutableArray *resArray = [NSMutableArray array];
//                for (NSDictionary *dic in array) {
//                    PartTaskModel *res = [PartTaskModel partTaskModel:dic currency:_act.currency];
//                    [resArray addObject:res];
//                }
//                [self.navigationController pushViewController:[ControllerFactory partSaleTaskViewControllerWithData:resArray activity:_act] animated:YES];
//            }
//            else {
//                [GlobalConfig showAlertViewWithMessage:ERROR superView:nil];
//            }
//        }];

}

//- (void) createAlertView
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加分销任务" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入分销名称"];
//    alert.delegate = self;
//    [alert show];
//}
//
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1 ) {
//        
//        UITextField *field = [alertView textFieldAtIndex:0];
//        if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:field.text]) {
//            self.loadingView.hidden = NO;
//                [[HTTPClient shareHTTPClient] addNewTaskWithTaskName:field.text
//                                                                 eid:_act.eid
//                                                             success:^(id jsonData) {
//                                                                 self.loadingView.hidden = YES;
//                            if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
//                                NSArray *array = [GlobalConfig convertToArray:jsonData[@"task"]];
//                                NSMutableArray *resArray = [NSMutableArray array];
//                                for (NSDictionary *dic in array) {
//                                    PartTaskModel *res = [PartTaskModel partTaskModel:dic currency:_act.currency];
//                                    [resArray addObject:res];
//                                }
//                                if (resArray.count > 0) {
//                                    [self.navigationController pushViewController:[ControllerFactory partSaleTaskViewControllerWithData:resArray activity:_act] animated:YES];
//                                }
//                                else {
//                                    [GlobalConfig alert:@"创建失败，请重新创建"];
//                                }
//                
//                            }
//                            else {
//                                [GlobalConfig alert:@"创建失败，请重新创建"];
//                            }
//                }];
//        }
//        else {
//            [GlobalConfig alert:@"名称不能为空，请重新创建任务"];
//        }
//    }
//}
//

@end
