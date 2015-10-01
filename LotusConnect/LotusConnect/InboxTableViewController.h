//
//  InboxTableViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSArray *unreadMessages;
@property (nonatomic, strong) PFObject *selectedMessage;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *usernameBarButton;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end
