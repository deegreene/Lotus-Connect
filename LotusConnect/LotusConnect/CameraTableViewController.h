//
//  CameraTableViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *imageOrVideoRecipients;

// for alphabetical scrolling
@property (nonatomic, strong) NSMutableDictionary *companiesDictionary;
@property (nonatomic, strong) NSMutableArray *companySectionTitles;
@property (nonatomic, strong) NSArray *companyIndexTitles;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

- (void)uploadMessage;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@end
