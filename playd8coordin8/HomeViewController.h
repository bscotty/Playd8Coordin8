//
//  HomeViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@import Firebase;


@interface HomeViewController : UIViewController
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSMutableArray<Event *> *events;
@property (nonatomic) NSDateFormatter* timeFormatter;
@property (nonatomic) NSUInteger inviteCount;
@property (nonatomic) NSUInteger commitmentCount;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventGuests;

//TODO: add username to welcomeLabel
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

//TODO: add current date to label
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;

//TODO: add current time to label
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

//TODO: get upcoming events array and return the size (these are events that you are already attending)
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventsLabel;

//TODO: get pending invites and return the size (these are events that you have decided not to attend)
@property (weak, nonatomic) IBOutlet UILabel *pendingInvitesLabel;

@end
