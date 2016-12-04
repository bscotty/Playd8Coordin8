//
//  HomeViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "HomeViewController.h"
#import "Event.h"
@import Firebase;

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Get our database reference.
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [_ref child:@"events"];
    
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    
    NSLog(@"PD8 We made it past the references and are waiting on the observation event.");
    
    [events observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"PD8 OBSERVING DATABASE");
        for(FIRDataSnapshot* child in snapshot.children) {
            NSLog(@"PD8 CHILD FOUND");
            // child = event object in database.
            Event *e = [[Event alloc] init];
            
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
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"PD8 OBSERVE ERROR");
        NSLog(@"%@", error.localizedDescription);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
