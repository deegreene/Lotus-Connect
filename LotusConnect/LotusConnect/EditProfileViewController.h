//
//  EditProfileViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *pickedImage;

@property (nonatomic, strong) PFUser *currentUser;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneEmailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;

@property (weak, nonatomic) IBOutlet UIButton *editInfoButton;

- (IBAction)cancel:(id)sender;
- (IBAction)logout:(id)sender;

@end
