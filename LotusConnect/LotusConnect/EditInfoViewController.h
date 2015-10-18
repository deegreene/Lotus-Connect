//
//  EditInfoViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 10/16/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditInfoViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) PFUser *currentUser;

//signup text fields
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) NSString *companyName;

- (IBAction)saveInfo:(id)sender;
- (IBAction)cancel:(id)sender;

@end
