//
//  EmailSupportViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 10/15/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface EmailSupportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *emailSupportButton;

@end
