//
//  TicketDetailViewController.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"
#import "WSDatePickerView.h"

@interface TicketDetailViewController : BaseViewController<WSDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ticketTitle;
@property (weak, nonatomic) IBOutlet UITextField *t_name;
@property (weak, nonatomic) IBOutlet UISwitch *isFree;
@property (weak, nonatomic) IBOutlet UITextField *t_price;
@property (weak, nonatomic) IBOutlet UITextField *t_num;
@property (weak, nonatomic) IBOutlet UITextField *original_num;
@property (weak, nonatomic) IBOutlet UITextField *order_min_num;
@property (weak, nonatomic) IBOutlet UITextField *order_max_num;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

- (IBAction)startDatePressed:(id)sender;
- (IBAction)endDatePressed:(id)sender;

- (IBAction)savePressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ticket:(Ticket *)ticket;
@end
