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
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
    self.events = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
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
            
            // Get the guests.
            for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                [[e guests] addObject:[guest value]];
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



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"PD8 TABLEVIEW ROWSINSECTION");
    return [self.events count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"PD8 TABLEVIEW SECTIONSINVIEW");
    return 1;
}

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
