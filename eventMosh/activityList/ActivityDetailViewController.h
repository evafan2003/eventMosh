//
//  ActivityDetailViewController.h
//  moshTickets
//
//  Created by 魔时网 on 14-6-27.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "WebViewController.h"
//#import "FXBlurView.h"
#import "Activity.h"


@interface ActivityDetailViewController : WebViewController


@property (weak, nonatomic) IBOutlet UIView *blurView;
- (IBAction)shareButtonClick:(id)sender;
- (IBAction)partButtonClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil activity:(Activity *)act;
@end
