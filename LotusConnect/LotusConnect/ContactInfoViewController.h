//
//  ContactInfoViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface ContactInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *faceTimeButton;


@property (weak, nonatomic) IBOutlet UILabel *contactCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *contactFullName;

@property PFUser *currentContact;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *companyName;
@property NSString *email;

@end
