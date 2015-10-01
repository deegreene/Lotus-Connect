//
//  EditProfileViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickedImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentUser = [PFUser currentUser];
    
    self.firstName = [self.currentUser objectForKey:@"firstName"];
    self.lastName = [self.currentUser objectForKey:@"lastName"];
    self.companyName = [self.currentUser objectForKey:@"companyName"];
    self.phone = [self.currentUser objectForKey:@"Phone"];
    self.email = [self.currentUser objectForKey:@"email"];
    
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    self.companyNameLabel.text = self.companyName;
    self.phoneEmailLabel.text = [NSString stringWithFormat:@"%@ | %@", self.phone, self.email];
    
    //set profile image
    if ([self.currentUser objectForKey:@"profileImage"] == nil) {
        self.profileImage.image = [UIImage imageNamed:@"friends"];
    }else {
        // download image from Parse.com
        PFFile *imageFile = [self.currentUser objectForKey:@"profileImage"];
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
       self.profileImage.image = [UIImage imageWithData:imageData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    // device will no longer receive pushes for that user
    [PFInstallation.currentInstallation removeObjectForKey:@"user"];
    [PFInstallation.currentInstallation saveEventually];
    
    [PFUser logOut];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Camera

- (void)promptForSource {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Profile Picture"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self promptForCamera];
                                                   }];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self promptForPhotoRoll];
                                                      }];
    
    UIAlertAction *removeImage = [UIAlertAction actionWithTitle:@"Remove Current Photo" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self.currentUser removeObjectForKey:@"profileImage"];
                                                       
                                                       [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                           if (error) {
                                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                               
                                                               [alertView show];
                                                           } else {
                                                               // everything was successful!
                                                               // dont do anything other than display a success message...user is already taken to inbox tab
                                                               //[self reset];
                                                               
                                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Profile image updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                               
                                                               [alertView show];
                                                               
                                                               self.profileImage.image = [UIImage imageNamed:@"friends"];
                                                               [self reset];
                                                           }
                                                       }];
                                                       
                                                       [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:photoRoll];
    [alert addAction:removeImage];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    NSData *fileData;
    NSString *fileName;
    
    // check if image or video
    if (self.pickedImage != nil) {
        // shrink the image
        UIImage *newImage = [self resizeImage:image toWidth:200.0f andHeight:200.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = [NSString stringWithFormat:@"%@-%@-profile.png", self.firstName, self.lastName];
    }
    
    //NSLog(@"file data: %@", fileData);
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        //        error = [[NSError alloc] init]; // to check for errors... comment to run!!!!
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        } else {
            // file is on Parse.com!
            //PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [self.currentUser setObject:file forKey:@"profileImage"];
            
            [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                } else {
                    // everything was successful!
                    // dont do anything other than display a success message...user is already taken to inbox tab
                    //[self reset];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Profile image updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    self.profileImage.image = self.pickedImage;
                    [self reset];
                }
            }];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    }else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}
 */

- (void)reset {
    self.pickedImage = nil;
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *reziedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reziedImage;
}

- (IBAction)imageTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

@end
