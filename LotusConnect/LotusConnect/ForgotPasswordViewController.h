//
//  ForgotPasswordViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 10/17/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)resetPassword:(id)sender;
- (IBAction)cancel:(id)sender;


@end
