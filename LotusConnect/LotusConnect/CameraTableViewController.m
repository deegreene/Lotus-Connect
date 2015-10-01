//
//  CameraTableViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "CameraTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface CameraTableViewController ()

@end

@implementation CameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    // create a mutable array to store the recipients of an image/video
    self.imageOrVideoRecipients = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.imageOrVideoRecipients.count == 0) {
        self.sendButton.enabled = NO;
    }
    
    // setting up the camera
    if (self.image == nil && [self.videoFilePath length] == 0) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 30; // video can be up to 30 secs
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // only use camera as source type if its available
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            // if camera is not available select from photo library
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // user CAN see ALL contacts
        
        //displaying contacts to send a picture/video to
        PFQuery *query = [PFUser query];
        [query orderByAscending:@"companyName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                self.contacts = objects;
                //NSLog(@"contacts names: %@", self.contacts);
                
                //alphabetical scroll code
                self.companiesDictionary = [[NSMutableDictionary alloc] init];
                
                BOOL found;
                
                // Loop through the books and create our keys
                for (NSDictionary *contact in self.contacts)
                {
                    NSString *c = [[contact objectForKey:@"companyName"] substringToIndex:1];
                    
                    found = NO;
                    
                    for (NSString *str in [self.companiesDictionary allKeys])
                    {
                        if ([str isEqualToString:c])
                        {
                            found = YES;
                        }
                    }
                    
                    if (!found)
                    {
                        [self.companiesDictionary setValue:[[NSMutableArray alloc] init] forKey:c];
                    }
                }
                
                // Loop again and sort the companies into their respective keys
                for (NSDictionary *contact in self.contacts)
                {
                    [[self.companiesDictionary objectForKey:[[contact objectForKey:@"companyName"] substringToIndex:1]] addObject:contact];
                }
                
                /*
                 // Sort each section array
                 for (NSString *key in [self.companiesDictionary allKeys])
                 {
                 [[self.companiesDictionary objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
                 }
                 */
                
                //NSLog(@"here: %@", self.companiesDictionary);
                
                //end alphabetical scroll code
                
                
                [self.tableView reloadData];
            }
        }];
    } else {
        // user can NOT see ALL contacts
        
        //displaying contacts to send a picture/video to
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName = 'Lotus Management Services'"];
        PFQuery *query = [PFUser queryWithPredicate:predicate];
        [query orderByAscending:@"companyName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                self.contacts = objects;
                //NSLog(@"contacts names: %@", self.contacts);
                
                //alphabetical scroll code
                self.companiesDictionary = [[NSMutableDictionary alloc] init];
                
                BOOL found;
                
                // Loop through the books and create our keys
                for (NSDictionary *contact in self.contacts)
                {
                    NSString *c = [[contact objectForKey:@"companyName"] substringToIndex:1];
                    
                    found = NO;
                    
                    for (NSString *str in [self.companiesDictionary allKeys])
                    {
                        if ([str isEqualToString:c])
                        {
                            found = YES;
                        }
                    }
                    
                    if (!found)
                    {
                        [self.companiesDictionary setValue:[[NSMutableArray alloc] init] forKey:c];
                    }
                }
                
                // Loop again and sort the companies into their respective keys
                for (NSDictionary *contact in self.contacts)
                {
                    [[self.companiesDictionary objectForKey:[[contact objectForKey:@"companyName"] substringToIndex:1]] addObject:contact];
                }
                
                /*
                 // Sort each section array
                 for (NSString *key in [self.companiesDictionary allKeys])
                 {
                 [[self.companiesDictionary objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
                 }
                 */
                
                //NSLog(@"here: %@", self.companiesDictionary);
                
                //end alphabetical scroll code
                
                
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //return 1;
    return [[self.companiesDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return self.contacts.count;
    return [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // user is a lotus employee and can see all contacts
        return [[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    } else {
        // user is a client and can only see lotus employees
        return @"Support";
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //return [[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // alphabetical scrolling enabled for lotus employees
        return self.companyIndexTitles;
    } else {
        // alphabetical scrolling disabled for clients
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //NSLog(@"%@ is at position %lu",title, (unsigned long)[[self.companiesDictionary allKeys] indexOfObject:title]);
    return [[self.companiesDictionary allKeys] indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //PFUser *user = [self.contacts objectAtIndex:indexPath.row];
    PFUser *user = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    NSString *firstName = [user objectForKey:@"firstName"];
    NSString *lastName = [user objectForKey:@"lastName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.detailTextLabel.text = [user objectForKey:@"companyName"];
    
    if (![[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        //user can only see and send to lotus employees
        if ([[user objectForKey:@"companyName"] isEqualToString:@"Lotus Management Services"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //NSLog(@"%@", self.imageOrVideoRecipients);
            [self.imageOrVideoRecipients addObject:[user objectId]];
            //NSLog(@"%@", self.imageOrVideoRecipients);
        }
    } else {
        //user can choose who to send to
        if ([self.imageOrVideoRecipients containsObject:[user objectId]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    //NSLog(@"%@", self.imageOrVideoRecipients);
    
    //only allow user to send message if recipients selected
    if (self.imageOrVideoRecipients.count == 0) {
        self.sendButton.enabled = NO;
    } else {
        self.sendButton.enabled = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO]; //deselect row when it's tapped
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //PFUser *user = [self.contacts objectAtIndex:indexPath.row];
    PFUser *user = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) { // user can choose who to send to
        // handle checkmarks for selecting recipient
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.imageOrVideoRecipients addObject:user.objectId]; // add contact if checked
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.imageOrVideoRecipients removeObject:user.objectId]; // remove contact if not
        }
        
    } else { // user can only send to lotus employees
        
        // do nothing
    }
    
    //only allow user to send message if recipients selected
    if (self.imageOrVideoRecipients.count == 0) {
        self.sendButton.enabled = NO;
    } else {
        self.sendButton.enabled = YES;
    }
}


#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //dismiss modal view
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.imageOrVideoRecipients removeAllObjects];
    
    // send user back to inbox after camera view is dismissed
    self.tabBarController.selectedIndex = 0;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // a photo was taken/selected!
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage]; // doc for UIImagePickerController
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save the image!
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        // a video was taken/selected!
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save the video!
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancel:(id)sender {
    
    [self reset];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)send:(id)sender {
    if (self.image == nil && self.videoFilePath.length == 0) {
        // no image or video
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Select a photo or video to share" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        [self uploadMessage];
        //[self reset]; // dont use reset here - will reset before message sending
        
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark - Helper methods

- (void)uploadMessage {
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    // check if image or video
    if (self.image != nil) {
        // if image, shrink it
        // future: detect size of iphone and resize accordingly
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        // video
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
//        error = [[NSError alloc] init]; // to check for errors... comment to run!!!!
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        } else {
            // file is on Parse.com!
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.imageOrVideoRecipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderEmail"];
            
            NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
            NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
            [message setValue:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"senderFullName"];
            
            [message setValue:[[PFUser currentUser] objectForKey:@"companyName"] forKey:@"senderCompany"];
            
            
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                } else {
                    // everything was successful!
                    
                    //push code
                    PFQuery *pushQuery = [PFInstallation query];
                    
                    PFQuery *recipients = [PFUser query];
                    [recipients whereKey:@"objectId" containedIn:self.imageOrVideoRecipients];
                    NSLog(@"%@", recipients);
                    
                    //send to msg recipients
                    [pushQuery whereKey:@"user" matchesQuery:recipients];

                    NSLog(@"query %@", pushQuery);
                    NSLog(@"sent to: %@", self.imageOrVideoRecipients);
                    
                    // Send push notification to query
                    NSString *companyName = [[PFUser currentUser] objectForKey:@"companyName"];
                    NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
                    NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
                    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                    NSDictionary *data = @{
                                           @"alert" : [NSString stringWithFormat:@"%@ : %@", fullName,companyName],
                                           @"badge" : @"Increment",
                                           @"sound" : UILocalNotificationDefaultSoundName
                                           };
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    //[push setChannel:@"allNotifications"];
                    [push setData:data];
                    [push sendPushInBackground];
                    
                    //end push code
                    
                    
                    // dont do anything other than display a success message...user is already taken to inbox tab
                    [self reset];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Message sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                }
            }];
        }
    }];
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.imageOrVideoRecipients removeAllObjects];
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

@end
