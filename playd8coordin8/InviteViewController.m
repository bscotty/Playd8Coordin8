//
//  InviteViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Handle Table View Information
    self.inviteTable.dataSource = self;
    self.inviteTable.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.inviteTable addGestureRecognizer:tap];
    
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [_ref child:@"events"];
    NSLog(@"PD8 We made it past the references and are waiting on the observation event.");
    
    [events observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"PD8 OBSERVING DATABASE");
        self.invites = [[NSMutableArray alloc] init];
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
            
            // Determine if we're attending the event.
            [e setIsAttending:@NO];
            for (id Guest in e.guests) {
                if([Guest isKindOfClass:NSString.class]) {
                    FIRUser *user = [FIRAuth auth].currentUser;
                    if([Guest isEqualToString:user.displayName]) {
                        [e setIsAttending:@YES];
                    }
                }
            }
            
            // Set the cell text.
            NSString * cellText = [[NSString alloc] initWithFormat:@"On %@ at %@ place with friend(s): ", e.getDateAndTimeForUI, e.location];
            for(id Guest in e.guests) {
                if([Guest isKindOfClass:NSString.class]) {
                    cellText = [[cellText stringByAppendingString:Guest] stringByAppendingString:@", "];
                }
            }
            
            [e setCellText:cellText];
            NSLog(@"PD8  capturing event: %@", e.cellText);
            if([e.date timeIntervalSinceNow] > -3600.0 && [e.isAttending isEqual:@NO]){
                [self.invites addObject:e];
            }
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
        [self.invites sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [self.inviteTable reloadData];
        
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
    CGPoint tapLocation = [recognizer locationInView:self.inviteTable];
    NSIndexPath *indexPath = [self.inviteTable indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        Event* e = self.invites[indexPath.row];
        
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
                                   FIRUser *user = [FIRAuth auth].currentUser;
                                   if(![e.guests containsObject:user.displayName]) {
                                       [e addGuest:user.displayName];
                                   }
                                   [self updateFirebaseWithEvent:e];
                               }];
        // Setup the Do Not Attend action,
        UIAlertAction* doNotAttendAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   e.isAttending = @NO;
                                   FIRUser *user = [FIRAuth auth].currentUser;
                                   if([e.guests containsObject:user.displayName]) {
                                       [e.guests removeObject:user.displayName];
                                   }
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
                           @"date": event.getDateAndTimeForFirebase,
                           @"location": event.location,
                           @"guests": event.guests};
    
    NSDictionary *childUpdates = @{[@"/events/" stringByAppendingString:event.key]: post};
    [_ref updateChildValues:childUpdates];
    [self.inviteTable reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"PD8 TABLEVIEW ROWSINSECTION");
    return [self.invites count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"PD8 TABLEVIEW SECTIONSINVIEW");
    NSInteger numOfSections = 0;
    if ([self.invites count] > 0)
    {
        self.inviteTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
        //yourTableView.backgroundView   = nil;
        self.inviteTable.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.inviteTable.bounds.size.width, self.inviteTable.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        //yourTableView.backgroundView = noDataLabel;
        //yourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.inviteTable.backgroundView = noDataLabel;
        self.inviteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"PD8 TABLEVIEW CALLED");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //Here the dataSource array is of dictionary objects
    Event *event = self.invites[indexPath.row];
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
