//
//  OrderSearchViewController.h
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"
@protocol OrderSearchDelegate;

@interface OrderSearchViewController : BaseViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *order_id;
@property (weak, nonatomic) IBOutlet UITextField *event_title;
@property (weak, nonatomic) IBOutlet UITextField *event_id;
@property (strong, nonatomic) NSString *status;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)order_status:(id)sender;

- (IBAction)search:(id)sender;
@property (nonatomic, assign) id<OrderSearchDelegate> delegate;
@end

@protocol OrderSearchDelegate <NSObject>

-(void) searchFinish:(NSDictionary *)theDic;

@end