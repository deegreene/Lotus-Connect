//
//  AppDelegate.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *const LayerAppIDString = @"layer:///apps/staging/2ae9c9be-69cc-11e5-8ed0-21ca02003d18";
static NSString *const ParseAppIDString = @"RgOpkkSfRoOFvealb8uUbdElx6e4VwqrNA0ObZLl";
static NSString *const ParseClientKeyString = @"GsMpLwqknU9c8qfPY0AaWUZzd7lE38ZTQQliM9TH";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [NSThread sleepForTimeInterval:1.5]; //display splash screen longer
    
    [self setupAppearance];
    
    // Parse.com setup
    [Parse setApplicationId:@"RgOpkkSfRoOFvealb8uUbdElx6e4VwqrNA0ObZLl"
                  clientKey:@"GsMpLwqknU9c8qfPY0AaWUZzd7lE38ZTQQliM9TH"];
    [PFUser enableRevocableSessionInBackground];
    
    // Parse Push notifications setup
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    //Layer code
    // Enable Parse local data store for user persistence
    [Parse enableLocalDatastore];
    [Parse setApplicationId:ParseAppIDString
                  clientKey:ParseClientKeyString];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Initializes a LYRClient object
    NSURL *appID = [NSURL URLWithString:LayerAppIDString];
    LYRClient *layerClient = [LYRClient clientWithAppID:appID];
    layerClient.autodownloadMIMETypes = [NSSet setWithObjects:ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation, nil];
    
    // Show View Controller
    ViewController *controller = [ViewController new];
    controller.layerClient = layerClient;
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupAppearance {
    // customize the navigation bar
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.barTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:70/255.0 alpha:1.0f];
    navigationBarAppearance.tintColor = [UIColor whiteColor];
    navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // customize the tab bar
    UITabBarItem *tabBarAppearance = [UITabBarItem appearance];
    [tabBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    //set color of icons to white

}

// push notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    //currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

// push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
