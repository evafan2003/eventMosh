//
//  FaqDetailViewController.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"

@interface FaqDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *checkMail;
@property (weak, nonatomic) IBOutlet UIImageView *checkSite;
@property (weak, nonatomic) IBOutlet UITextField *mailField;

@property (weak, nonatomic) IBOutlet UITextView *reply;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil faq:(Faq *)faq;

- (IBAction)sendMail:(id)sender;
- (IBAction)sendSite:(id)sender;
- (IBAction)save:(id)sender;


@end
