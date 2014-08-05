//
//  FaqDetailViewController.m
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "FaqDetailViewController.h"
#import "FaqCell.h"

@interface FaqDetailViewController ()

@end

@implementation FaqDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil faq:(Faq *)faq {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        _act = act;
        //        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://e.mosh.cn/%@",_act.eid]];
        self.title = NAVTITLE_FAQDETAIL;
    }
    return self;
}

- (IBAction)sendMail:(id)sender {
    if (self.checkMail.hidden) {
        self.checkMail.hidden = NO;
    } else {
        self.checkMail.hidden = YES;
    }
}

- (IBAction)sendSite:(id)sender {
    if (self.checkSite.hidden) {
        self.checkSite.hidden = NO;
    } else {
        self.checkSite.hidden = YES;
    }
}

- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FaqCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FaqCell class]) owner:self options:nil][0];
    cell.frame = CGRectMake(0, 0, 320, 150);
    [self.view addSubview:cell];
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:NAVTITLE_FAQDETAIL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
