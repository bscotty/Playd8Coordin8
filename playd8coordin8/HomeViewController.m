//
//  HomeViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "HomeViewController.h"
#import "RootController.h"
#import "Event.h"
@import Firebase;

@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.events = [[NSMutableArray alloc] init];
    //load an array with 3> upcoming events and "your" events from database into array
    
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [_ref child:@"events"];
    NSLog(@"PD8 We made it past the references and are waiting on the observation event.");
    
    [events observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"PD8 OBSERVING DATABASE");
        for(FIRDataSnapshot* child in snapshot.children) {
            NSLog(@"PD8 CHILD FOUND");
            // child = event object in database.
            Event *e = [[Event alloc] init];
            
            // Get the Firebase Key, along with the date, time, and location.
            [e setKey:[child key]];
            [e setName:[[child childSnapshotForPath:@"name"] value]];
            [e setDate:[[child childSnapshotForPath:@"date"] value]];
            [e setTime:[[child childSnapshotForPath:@"time"] value]];
            [e setLocation:[[child childSnapshotForPath:@"location"] value]];
            
            if([[[child childSnapshotForPath:@"attending"] value] isEqual: @1]){
                [e setIsAttending: @YES];
            }
            if([[[child childSnapshotForPath:@"attending"] value] isEqual: @0]){
                [e setIsAttending: @NO];
            }
            
            
            // Get the guests.
            for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                [[e guests] addObject:[guest value]];
            }
            if([e.isAttending isEqual: @YES]){
                [self.events addObject: e];
            }
    
        }
        if([self.events count] > 0){
            Event* currentEvent = self.events[0];
            self.eventName.text = currentEvent.name;
            self.eventDate.text = currentEvent.date;
            self.eventTime.text = currentEvent.time;
            self.eventLocation.text = currentEvent.location;
            NSMutableString* guestList = [[NSMutableString alloc] initWithFormat:@""];
            for(int i = 0; i < currentEvent.guests.count; i++){
                [guestList appendString: currentEvent.guests[i]];
            }
            self.eventGuests.text = guestList;
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

#pragma mark - Table view data source



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
