//
//  AppDelegate.m
//  Layer-Parse-iOS-Example
//
//  Created by Kabir Mahal on 3/25/15.
//  Copyright (c) 2015 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <LayerKit/LayerKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

static NSString *const LayerAppIDString = @"layer:///apps/staging/2ae9c9be-69cc-11e5-8ed0-21ca02003d18";
static NSString *const ParseAppIDString = @"RgOpkkSfRoOFvealb8uUbdElx6e4VwqrNA0ObZLl";
static NSString *const ParseClientKeyString = @"GsMpLwqknU9c8qfPY0AaWUZzd7lE38ZTQQliM9TH";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (LayerAppIDString.length == 0 || ParseAppIDString.length == 0 || ParseClientKeyString.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Configuration" message:@"You have not configured your Layer and/or Parse keys. Please check your configuration and try again." delegate:nil cancelButtonTitle:@"Rats!" otherButtonTitles:nil];
        [alertView show];
        return YES;
    }
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

@end
