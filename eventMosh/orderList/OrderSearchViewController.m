//
//  OrderSearchViewController.m
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "OrderSearchViewController.h"

@interface OrderSearchViewController ()

@end

@implementation OrderSearchViewController
@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_SEARCH];
    self.order_id.keyboardType = UIKeyboardTypeNumberPad;
    self.event_title.keyboardType = UIKeyboardTypeDefault;
    self.event_id.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)order_status:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部",@"已付款",@"未支付",@"已取消",@"已退款", nil];
    [as showInView:self.view];
}

- (IBAction)search:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSLog(@"%@",self.order_id.text);
    NSLog(@"%@",self.event_title.text);
    NSLog(@"%@",self.event_id.text);
    //    return;
    [dic setValue:self.order_id.text forKey:@"o_id"];
    [dic setValue:self.event_title.text forKey:@"title"];
    [dic setValue:self.event_id.text forKey:@"eid"];
    [dic setValue:self.status forKey:@"status"];
    
    [delegate searchFinish: dic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    self.status = [NSString stringWithFormat:@"%d",buttonIndex];
    self.statusLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
}
@end
