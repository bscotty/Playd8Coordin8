//
//  ViewController.m
//  PlaydateCoordinate
//
//  Created by Bryan Scott on 11/17/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "RootController.h"

//Views from tab bar
#import "HomeViewController.h"
#import "InviteViewController.h"
#import "EventViewController.h"
#import "UserViewController.h"

// Add this to the header of your file, e.g. in ViewController.m
// after #import "ViewController.h"
#import "Event.h"


@interface RootController ()


@end

@implementation RootController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PD8 ROOT CONTROLLER VIEWDIDLOAD. SEARCHING FOR VIEW CONTROLLERS.");
    
    // Get our View Controllers and associate them with the right types.
    for (UIViewController *v in self.viewControllers) {
        UIViewController *vc = v;
        // Get the View Controllers.
        if ([vc isKindOfClass:[HomeViewController class]]) {
            self.homeViewController = (HomeViewController*) vc;
            NSLog(@"PD8 HOME VIEW CONTROLLER FOUND");
        } else if ([vc isKindOfClass:[InviteViewController class]]) {
            self.inviteViewController = (InviteViewController*) vc;
            NSLog(@"PD8 INVITE VIEW CONTROLLER FOUND");
        } else if ([vc isKindOfClass:[EventViewController class]]) {
            self.eventViewController = (EventViewController*) vc;
            NSLog(@"PD8 EVENT VIEW CONTROLLER FOUND");
        } else if ([vc isKindOfClass:[UserViewController class]]) {
            self.userViewController = (UserViewController*) vc;
            NSLog(@"PD8 USER VIEW CONTROLLER FOUND");
        }
    }
    
    
    // Get our database reference.
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [_ref child:@"events"];
    NSLog(@"PD8 We made it past the references and are waiting on the observation event.");
    
    // Get all our events as event objects.
    [events observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"PD8 OBSERVING DATABASE");
        for(FIRDataSnapshot* child in snapshot.children) {
            NSLog(@"PD8 CHILD FOUND");
            // child = event object in database.
            Event *e = [[Event alloc] init];
            
            // Get the Firebase Key, along with the date, time, and location.
            [e setKey:[child key]];
            [e setDate:[[child childSnapshotForPath:@"date"] value]];
            [e setTime:[[child childSnapshotForPath:@"time"] value]];
            [e setLocation:[[child childSnapshotForPath:@"location"] value]];
            
            // Get the guests.
            for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                [[e guests] addObject:[guest value]];
            }
            [self.eventList addObject:e];
            
        }
    // Handle Cancelations, so we know for debugging purposes.
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"PD8 OBSERVE ERROR");
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Puts the Event object onto Firebase.
- (void) updateFirebaseWithEvent:(Event*)event {
    FIRDatabaseReference *events = [_ref child:@"events"];
    
    NSString* eventKey = [[events childByAutoId] key];
    [[events child:eventKey] setValue:event.time forKey:@"time"];
    [[events child:eventKey] setValue:event.date forKey:@"date"];
    [[events child:eventKey] setValue:event.location forKey:@"location"];
    [[events child:eventKey] setValue:event.isAttending forKey:@"attending"];
}

// Do these do things??? Can they????
-(IBAction) switchToInviteView:(id)sender{
    self.inviteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Invite"];
    self.inviteViewController.view.frame = self.view.frame;
    //not sure if this will work
    [self presentViewController:self.inviteViewController animated:YES completion:nil];
}

-(IBAction) switchToEventView:(id)sender{
    self.eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Event"];
    self.eventViewController.view.frame = self.view.frame;
    [self presentViewController:self.eventViewController animated:YES completion:nil];
}

-(IBAction) switchToUserView:(id)sender{
    self.userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"User"];
    self.userViewController.view.frame = self.view.frame;
    [self presentViewController:self.userViewController animated:YES completion:nil];
}

-(IBAction) switchToHomeView:(id)sender{
    self.homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    self.homeViewController.view.frame = self.view.frame;
    [self presentViewController:self.homeViewController animated:YES completion:nil];
}
@end
