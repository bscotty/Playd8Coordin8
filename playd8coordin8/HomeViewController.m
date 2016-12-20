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
    self.ref = [[FIRDatabase database] reference];
    self.events = [[NSMutableArray alloc] init];
    //load an array with 3> upcoming events and "your" events from database into array
    if([[FIRAuth auth] currentUser]){
        FIRUser *user = [FIRAuth auth].currentUser;
        NSString *name = user.displayName;
        NSString *welcomeText = [[NSString alloc] initWithFormat:@"Welcome %@", name];
        _welcomeLabel.text = welcomeText;
        
        // Update the user's name in the database.
        NSDictionary* usernameUpdate = @{[[@"/users/" stringByAppendingString:user.uid] stringByAppendingString:@"/username/"]:
                                             [user displayName]};
        [_ref updateChildValues:usernameUpdate];
    }
    
    // Initialize some UI Objects for the current date and time.
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSString *dateString = [dateFormatter stringFromDate:date];
    _currentDateLabel.text = dateString;
    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *timeString = [self.timeFormatter stringFromDate:date];
    _currentTimeLabel.text = timeString;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateTime:) userInfo:nil repeats:YES];
    
    // Setup the Observation Event.
    FIRDatabaseReference *eventRef = [_ref child:@"events"];
    NSLog(@"PD8 We made it past the references and are waiting on the observation event."); /* Debug */
    
    // Get all the Events from the database.
    [eventRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"PD8 OBSERVING DATABASE");
        [self.events removeAllObjects];
        for(FIRDataSnapshot* child in snapshot.children) {
            NSLog(@"PD8 CHILD FOUND");
            // child = event object in database.
            Event *e = [[Event alloc] init];
            
            // Get the Firebase Key, along with the date, time, and location.
            [e setKey:[child key]];
            [e setName:[[child childSnapshotForPath:@"name"] value]];
            [e setDateFromFormattedString:[[child childSnapshotForPath:@"date"] value]];
            [e setLocation:[[child childSnapshotForPath:@"location"] value]];
            
            
            // Get the guests.
            for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                [e addGuest:guest.value];
            }
            
            // Determine if the current user is attending.
            [e setIsAttending:@NO];
            
            for (id Guest in e.guests) {
                if([Guest isKindOfClass:NSString.class]) {
                    FIRUser *user = [FIRAuth auth].currentUser;
                    if([Guest isEqualToString:user.displayName]) {
                        [e setIsAttending:@YES];
                    }
                }
            }
            
            // If the event has already passed, don't add it to our events.
            if([e.date timeIntervalSinceNow] > -3600.0) {
                [self.events addObject: e];
            }
        }
        if([self.events count] > 0) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
            [_events sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            Event* currentEvent = self.events[0];
            _eventName.text = currentEvent.name;
            _eventDate.text = currentEvent.getDateAndTimeForUI;
            _eventLocation.text = currentEvent.location;
            NSMutableString* guestList = [[NSMutableString alloc] initWithFormat:@""];
            for(int i = 0; i < currentEvent.guests.count; i++) {
                [guestList appendString: currentEvent.guests[i]];
            }
            _eventGuests.text = guestList;
        }

        // Determine the number of events attending / not attending
        self.inviteCount = 0;
        self.commitmentCount = 0;
        for (int i = 0; i < self.events.count; i++) {
            if([self.events[i].isAttending isEqual: @YES]) {
                self.commitmentCount++;
            } else {
                self.inviteCount++;
            }
        }
        // Update the UI
        NSString *inviteCountString = [[NSString alloc] initWithFormat:@"You have %lu pending invites.", (unsigned long)self.inviteCount];
        _pendingInvitesLabel.text = inviteCountString;
        NSString *commitmentCountString = [[NSString alloc] initWithFormat:@"You have %lu upcoming events", self.commitmentCount];
        _upcomingEventsLabel.text = commitmentCountString;
        
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

-(void)UpdateTime:(id)sender
{
    NSString *currentTime  = [self.timeFormatter stringFromDate:[NSDate date]];
    self.currentTimeLabel.text = currentTime;

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
