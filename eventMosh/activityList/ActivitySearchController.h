//
//  ActivitySearchController.h
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"

@protocol ActivitySearchDelegate;

@interface ActivitySearchController : BaseViewController
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *idField;

@property (nonatomic, assign) id<ActivitySearchDelegate> delegate;

@end

@protocol ActivitySearchDelegate <NSObject>

-(void) searchFinish:(NSDictionary *)theDic;

@end