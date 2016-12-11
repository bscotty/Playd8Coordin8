//
//  EventViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
#import "Event.h"

@interface EventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *eventTableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) NSMutableArray<Event*> *events;

@end
