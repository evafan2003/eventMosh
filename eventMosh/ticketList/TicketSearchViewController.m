//
//  TicketSearchViewController.m
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "TicketSearchViewController.h"

@interface TicketSearchViewController ()

@end

@implementation TicketSearchViewController

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
    
    self.ticket_id.keyboardType = UIKeyboardTypeNumberPad;
    self.ticket_name.keyboardType = UIKeyboardTypeDefault;
    self.event_name.keyboardType = UIKeyboardTypeDefault;
    self.event_id.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSLog(@"%@",self.ticket_id.text);
//    NSLog(@"%@",self.event_name.text);
//    NSLog(@"%@",self.event_id.text);

    [dic setValue:self.ticket_id.text forKey:@"ticket_id"];
    [dic setValue:self.ticket_name.text forKey:@"ticket_name"];
    [dic setValue:self.event_name.text forKey:@"event_name"];
    [dic setValue:self.event_id.text forKey:@"eid"];

    
    [delegate searchFinish: dic];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
