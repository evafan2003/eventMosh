//
//  TicketSearchViewController.h
//  eventMosh
//
//  Created by evafan2003 on 14-8-29.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"

@protocol TicketSearchDelegate;

@interface TicketSearchViewController : BaseViewController

- (IBAction)search:(id)sender;

@property (nonatomic, assign) id<TicketSearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *event_name;
@property (weak, nonatomic) IBOutlet UITextField *event_id;
@property (weak, nonatomic) IBOutlet UITextField *ticket_id;
@property (weak, nonatomic) IBOutlet UITextField *ticket_name;


@end

@protocol TicketSearchDelegate <NSObject>

-(void) searchFinish:(NSDictionary *)theDic;

@end