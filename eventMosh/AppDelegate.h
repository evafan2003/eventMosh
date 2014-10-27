//
//  AppDelegate.h
//  eventMosh
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerFactory.h"
#import "WSEncryption.h"
#import <Frontia/Frontia.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIPrintInteractionControllerDelegate>

@property (strong, nonatomic) DDMenuController  *menuController;
@property (strong, nonatomic) UIWindow *window;

@end
