//
//  LeftViewController.h
//  Movie
//
//  Created by mosh on 13-5-26.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoshNavigationController;

@interface LeftViewController : UIViewController
{

}
- (IBAction)buttonPressWithTouchUpInside:(id)sender;
@property (strong, nonatomic) UIView *alphaView;

@property (strong, nonatomic) MoshNavigationController *rootNav;
@property (strong, nonatomic) MoshNavigationController *actNav;
@property (strong, nonatomic) MoshNavigationController *newsNav;
@property (strong, nonatomic) MoshNavigationController *photoNav;
@property (strong, nonatomic) MoshNavigationController *weiboNav;
@property (strong, nonatomic) MoshNavigationController *moreNav;
@property (strong, nonatomic) MoshNavigationController *partnerNav;
@property (strong, nonatomic) MoshNavigationController *favoriteNav;

@property (assign, nonatomic) NSInteger  selButtonTag;
@property (weak, nonatomic) IBOutlet UIView *leftButtonView;
- (IBAction)logOut:(id)sender;

@end
