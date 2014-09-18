//
//  ActivitySearchController.m
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "ActivitySearchController.h"

@interface ActivitySearchController ()

@end

@implementation ActivitySearchController
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
    self.idField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSLog(@"%@",self.titleField.text);
    NSLog(@"%@",self.idField.text);
//    return;
    [dic setValue:self.titleField.text forKey:@"title"];
    [dic setValue:self.idField.text forKey:@"id"];
    
    [delegate searchFinish: dic];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
