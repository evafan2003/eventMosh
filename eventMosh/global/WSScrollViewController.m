//
//  WSScrollViewController.m
//  moshTickets
//
//  Created by 魔时网 on 14-5-28.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "WSScrollViewController.h"
#import "GlobalConfig.h"

@interface WSScrollViewController ()

@end

@implementation WSScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithScrollModel:(ScrollModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createBarWithLeftBarItem:MoshNavigationBarItemBack rightBarItem:MoshNavigationBarItemNone title:_model.title];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)];
    CGRect imageViewRect = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame),CGRectGetHeight(scrollView.frame));
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_model.image];
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    if (_model.orientation == ScrollOrientation_horizontal) {
        scrollView.contentSize = CGSizeMake(_model.image.size.width, CGRectGetHeight(scrollView.frame));
        imageViewRect.size.width = _model.image.size.width;
        imageView.frame = imageViewRect;
        scrollView.pagingEnabled = YES;
    }
    else {
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), _model.image.size.height);
        imageViewRect.size.height = _model.image.size.height;
        imageView.frame = imageViewRect;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ScrollModel

- (id) initWithDictionary:(NSDictionary *)dic scrollOrientation:(ScrollOrientation)orientation
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.orientation = orientation;
    }
    return self;
}

@end
