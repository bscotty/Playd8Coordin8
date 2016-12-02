//
//  ViewController.m
//  PlaydateCoordinate
//
//  Created by Bryan Scott on 11/17/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ViewController.h"

// Add this to the header of your file, e.g. in ViewController.m
// after #import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Event.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Get our database reference.
    self.ref = [[FIRDatabase database] reference];
    
    FIRDatabaseReference *events = [_ref child:@"events"];
    
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    
    [events observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for(FIRDataSnapshot* child in snapshot.children) {
            // child = event object in database.
            Event *e = [[Event alloc] init];
            if([child exists]) {
                // Get the date, time, and location.
                [e setDate:[[child childSnapshotForPath:@"date"] value]];
                [e setTime:[[child childSnapshotForPath:@"time"] value]];
                [e setLocation:[[child childSnapshotForPath:@"location"] value]];
                
                // Get the guests.
                for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                    [[e guests] addObject:guest.value];
                }
                [eventList addObject:e];
            }
        }
    }];
    
    
    /* Commenting out the Login Stuff since we're probably not doing that?
     FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        // TODO: move directly to the dashboard.
    } else {
        // Optional: Place the button in the center of your view.
        loginButton.center = self.view.center;
        [self.view addSubview:loginButton];
        loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    }*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
