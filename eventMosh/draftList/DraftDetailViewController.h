//
//  DraftDetailViewController.h
//  eventMosh
//
//  Created by  evafan2003 on 14-8-5.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"

@interface DraftDetailViewController : BaseViewController<UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UISwitch *theSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)switchPass:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil draft:(Draft *)act;
- (IBAction)save:(id)sender;
- (IBAction)changeType:(id)sender;
@end
