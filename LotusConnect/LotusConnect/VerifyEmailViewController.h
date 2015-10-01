//
//  VerifyEmailViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface VerifyEmailViewController : UIViewController

@property NSString *email;
@property (weak, nonatomic) IBOutlet UILabel *verifyEmailLabel;

- (IBAction)checkVerification:(id)sender;

@end
