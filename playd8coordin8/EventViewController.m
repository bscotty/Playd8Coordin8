//
//  EventViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import "RootController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Handle Table View Information
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.eventTableView addGestureRecognizer:tap];
    
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [_ref child:@"events"];
    NSLog(@"PD8 We made it past the references and are waiting on the observation event.");
    
    [events observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) { NSLog(@"PD8 OBSERVING DATABASE");
        self.events = [[NSMutableArray alloc] init];
        self.ref = [[FIRDatabase database] reference];
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
                [e addGuest:guest.value];
            }
            
            NSString * cellText = [[NSString alloc] initWithFormat:@"On %@ date at %@ time at %@ place with friend(s): %@ ", e.date, e.time , e.location, e.guests];
            
            [e setCellText:cellText];
            NSLog(@"PD8  capturing event: %@", e.cellText);
            [self.events addObject:e];
        }
        NSLog(@"PD8:  before reload events: %@", self.events[0].cellText);
        [self.eventTableView reloadData];
        NSLog(@"PD8: after reload events: %@", self.events[0].cellText);
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


-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.eventTableView];
    NSIndexPath *indexPath = [self.eventTableView indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        Event* e = self.events[indexPath.row];
        
        recognizer.cancelsTouchesInView = NO;
        
        // Setup the alert, which creates a popup.
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:[e.name stringByAppendingString:@"!"]
                                    message:e.cellText
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        // Setup the Attend Action, which changes the event to attending.
        UIAlertAction* attendAction =
        [UIAlertAction actionWithTitle:@"Attend"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   e.isAttending = @YES;
                                   [self updateFirebaseWithEvent:e];
                               }];
        // Setup the Do Not Attend action,
        UIAlertAction* doNotAttendAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   e.isAttending = @NO;
                                   [self updateFirebaseWithEvent:e];
                               }];
        
        [alert addAction:attendAction];
        [alert addAction:doNotAttendAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else { // anywhere else, do what is needed for your case
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) updateFirebaseWithEvent:(Event*)event {
    NSDictionary *post = @{@"attending": event.isAttending,
                           @"name": event.name,
                           @"time": event.time,
                           @"date": event.date,
                           @"location": event.location,
                           @"guests": event.guests};
    
    NSDictionary *childUpdates = @{[@"/events/" stringByAppendingString:event.key]: post};
    [_ref updateChildValues:childUpdates];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"PD8 TABLEVIEW ROWSINSECTION");
    return [self.events count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"PD8 TABLEVIEW SECTIONSINVIEW");
    NSInteger numOfSections = 0;
    if ([self.events count] > 0)
    {
        self.eventTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
        //yourTableView.backgroundView   = nil;
        self.eventTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.eventTableView.bounds.size.width, self.eventTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        //yourTableView.backgroundView = noDataLabel;
        //yourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.eventTableView.backgroundView = noDataLabel;
        self.eventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"PD8 TABLEVIEW CALLED");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //Here the dataSource array is of dictionary objects
    Event *event = self.events[indexPath.row];
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.cellText;
    
    return cell;
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
