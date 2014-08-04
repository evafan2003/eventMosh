//
//  MoshNavigationController.m
//  jazz
//
//  Created by mosh on 13-8-21.
//  Copyright (c) 2013年 com.mosh. All rights reserved.
//

#import "MoshNavigationController.h"
#import "ControllerFactory.h"

@interface MoshNavigationController ()

@end

@implementation MoshNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIMAGE] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = BACKGROUND;
    
    //标题字体变成白色
    if ([GlobalConfig versionIsIOS7]) {
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
