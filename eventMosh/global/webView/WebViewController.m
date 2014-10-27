//
//  WebViewController.h
//  MusicFestival
//
//  Created by  evafan2003 on 12-12-20.
//  Copyright (c) 2012年 cn.mosh. All rights reserved.
//

#import "WebViewController.h"
#import "GlobalConfig.h"
#import "MBProgressHUD.h"
#import <Frontia/Frontia.h>
#import "ShareMethod.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title URL:(NSURL *)theUrl showToolBar:(BOOL)show act:(NSString *)act
{
    self = [super init];
    if (self) {
        self.title = title;
        self.URL = theUrl;
        self.showButtom = show;
        self.activity = [Activity  new];
        self.activity.title = act;
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
   
    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:self.title];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT - NAVHEIGHT - STATEHEIGHT)];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
    if (self.showButtom) {
        [self createButtomBar];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}


//创建底部菜单
- (void)createButtomBar {
    UIView *buttom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-NAVHEIGHT-49, SCREENWIDTH, 49)];
    buttom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_buttom"]];
    [self.webView addSubview:buttom];

    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setTitle:@"分享" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [left setTitleColor:[UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.000] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 160, 49);
    left.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [buttom addSubview:left];

    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"复制链接" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(copyUrl) forControlEvents:UIControlEventTouchUpInside];
    [right setTitleColor:[UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.000] forState:UIControlStateNormal];
    right.frame = CGRectMake(160, 0, 160, 49);
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [buttom addSubview:right];
}


-(void)share {
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = [self.URL absoluteString];
    content.title = self.activity.title;

    content.description = [NSString stringWithFormat:@"刚刚发现一个不错的活动，赶快来报名参加吧：“%@”",self.activity.title];
    content.imageObj = self.activity.imageUrl;
    
    [ShareMethod shareWithContent:content];
}


-(void) copyUrl {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.URL absoluteString];
    [GlobalConfig alert:@"已将链接复制到剪切板"];
}

#pragma mark - webViewDelegate -
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (self.URL && !self.alv) {
        [self.webView stopLoading];
        self.alv = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"加载失败，请检查网络连接！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再试一次",nil];
        [self.alv show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.alv = nil;
    if (buttonIndex == 1) {
        //再试一次
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        
    }
    else {
        //取消
//        [self.navigationController popViewControllerAnimated:YES];
        [GlobalConfig push:NO viewController:self withNavigationCotroller:self.navigationController animationType:ANIMATIONTYPE_POP subType:ANIMATIONSUBTYPE_POP Duration:DURATION];
    }
}

- (void) navBackClick
{
    [GlobalConfig push:NO viewController:self withNavigationCotroller:self.navigationController animationType:ANIMATIONTYPE_POP subType:ANIMATIONSUBTYPE_POP Duration:DURATION];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
