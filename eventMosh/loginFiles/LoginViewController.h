//
//  LoginViewController.h
//  moshTicket
//
//  Created by 魔时网 on 13-11-12.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *checkNumber;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)login:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)urlButtonPress:(id)sender;
- (IBAction)checkButtonPress:(id)sender;

@end
