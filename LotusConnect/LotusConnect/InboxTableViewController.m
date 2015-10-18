//
//  InboxTableViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "InboxTableViewController.h"
#import "LoginViewController.h"
#import "ImageViewController.h"

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    // check if a user is logged in
    if (currentUser) {
        //NSLog(@"currentuser: %@", currentUser.username);
    } else {
        // if not take them to the login page/.
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshMessages)
                  forControlEvents:UIControlEventValueChanged];
    
    // round buttons
    self.emailSupportButton.layer.cornerRadius = CGRectGetWidth(self.emailSupportButton.frame) / 2.0f;
    self.callSupportButton.layer.cornerRadius = CGRectGetWidth(self.callSupportButton.frame) / 2.0f;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getAllMessages];
    
    [self.tableView reloadData];
}

- (void)getAllMessages {
    // get the messages
    
    PFUser *currentUser = [PFUser currentUser];
    
    //check if user is logged in or app will crash
    if ([[PFUser currentUser] objectId] != nil) {
        
        // Associate the device with a user
        PFInstallation *installation = [PFInstallation currentInstallation];
        //installation[@"user"] = [PFUser currentUser];
        [installation setObject:currentUser forKey: @"user"];
        NSString *firstName = [currentUser objectForKey:@"firstName"];
        NSString *lastName = [currentUser objectForKey:@"lastName"];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        [installation setValue:fullName forKey:@"userName"];
        [installation setValue:[currentUser objectForKey:@"companyName"] forKey:@"userCompany"];
        
        // if user is lotus employee subscribe them to all notifications channel
        if ([[currentUser objectForKey:@"companyName"] isEqualToString:@"Lotus Management Services"]) {
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:@"allNotifications" forKey:@"channels"];
        }
        
        [installation setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMessages.count] forKey:@"badge"];
        [installation saveInBackground];
        
        //self.usernameBarButton.title = [currentUser objectForKey:@"firstName"];
        //
        PFQuery *sentMessages = [PFQuery queryWithClassName:@"Messages"];
        [sentMessages whereKey:@"senderId" equalTo:[[PFUser currentUser] objectId]];
        
        PFQuery *receivedMessages = [PFQuery queryWithClassName:@"Messages"];
        [receivedMessages whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[sentMessages,receivedMessages]];
        //
        
        //PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
        //[query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                // messages were found!
                self.messages = [NSMutableArray arrayWithArray:objects];
                
                //find unread messages
                [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
                [query whereKey:@"readBy" notEqualTo:[[PFUser currentUser] objectId]];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                 {
                     if (!error)
                     {
                         self.unreadMessages = [NSMutableArray arrayWithArray:objects];
                         //NSLog(@"unread: %@", self.unreadMessages);
                         // set badge # to number of msgs
                         if (self.unreadMessages.count > 0)
                         {
                             [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)self.unreadMessages.count];
                             
                             //update bage in parse intallation
                             [installation setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMessages.count] forKey:@"badge"];
                         } else {
                             [[self navigationController] tabBarItem].badgeValue = nil;
                             
                             //update badge in parse installation
                             [installation setValue:@"0" forKey:@"badge"];
                         }
                         [self.tableView reloadData];
                     }
                 }];
            }
        }];
    } else {
        // if not take them to the login page
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

}

// for pull to refresh
- (void)refreshMessages {
    
    // get new messages
    [self getAllMessages];
    
    // Reload table data
    [self.tableView reloadData];
    
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy, h:mm a"];
    NSString *date = [dateFormatter stringFromDate:message.createdAt];

    
    //look for messages that user sent to someone other than themself
    if ([[message objectForKey:@"senderId"] isEqualToString:[[PFUser currentUser] objectId]] &&
        ![[message objectForKey:@"recipientIds"] containsObject:[[PFUser currentUser] objectId]]) {
        
        //sent message found
        cell.textLabel.text = @"Sent Message";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.text = date;
        
    } else { // user receieved a message
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",[message objectForKey:@"senderFullName"] , [message objectForKey:@"senderCompany"]];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = date;
        
        //NSLog(@"%lu", (unsigned long)self.unreadMessages.count);
        if ([[message objectForKey:@"readBy"] containsObject:[[PFUser currentUser] objectId]]) {
            // read message found
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            // unread message found
            cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:70/255.0 alpha:1.0f];
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
        }
        /* unncomment for date
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"MMM dd, yyyy, HH:mm"];
         NSString *date = [dateFormatter stringFromDate:message.createdAt];
         NSLog(@"message sent on %@", date);
         cell.detailTextLabel.text = date;
         
         NSString *fileType = [message objectForKey:@"fileType"];
         if ([fileType isEqualToString:@"image"]) {
         cell.imageView.image = [UIImage imageNamed:@"icon_image"]; //icon from project
         } else {
         cell.imageView.image = [UIImage imageNamed:@"icon_video"];
         }
         
         */
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    //NSMutableArray *mutableMessages = [NSMutableArray arrayWithArray:self.messages];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
        //NSLog(@"Recipients: %@", recipientIds);
        
        if (recipientIds.count == 1) {
            // last recipient - delete the msg
            [self.selectedMessage deleteInBackground];
        } else {
            // remove the recipient and save it
            [recipientIds removeObject:[[PFUser currentUser] objectId]];
            [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
            [self.selectedMessage saveInBackground];
        }
        [self.messages removeObjectAtIndex:indexPath.row]; // remove the cell from the table view
        [tableView reloadData]; // reload the table view
    }
    
    /* code only works once
    NSInteger *badgeNumber = (NSInteger *)self.unreadMessages.count;
    [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)badgeNumber - 1];
    */
    
    // reload the table view
    [tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    // mark message as read
    NSMutableArray *readByIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"readBy"]];
    
    if ([readByIds containsObject:[[PFUser currentUser] objectId]]) {
        // message has already been read. do nothing
    }else {
        // message was unread. mark it as read now.
        [readByIds addObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:readByIds forKey:@"readBy"];
        [self.selectedMessage saveInBackground];
    }
    
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        // file type is image
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        // file type is video
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        // add it to the view controller so we can see it
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.unreadMessages removeObjectAtIndex:indexPath.row];
//}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        LoginViewController *lvc = (LoginViewController *)segue.destinationViewController;
        [lvc setHidesBottomBarWhenPushed:YES];
        lvc.navigationItem.hidesBackButton = YES;
        //[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        [ivc setHidesBottomBarWhenPushed:YES];
        ivc.message = self.selectedMessage;
    }
}

- (void)reloadTable:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Support

- (IBAction)callSupport:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lotus Management Support"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"Call Support" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       NSString *phone = @"tel:4077490019";
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    [alert addAction:call];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
