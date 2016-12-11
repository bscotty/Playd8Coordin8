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
    // Do any additional setup after loading the view.
    self.inviteTable.dataSource = self;
    self.inviteTable.delegate = self;
    self.invites = [[NSMutableArray alloc] init];
    
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
            [e setDate:[[child childSnapshotForPath:@"date"] value]];
            [e setTime:[[child childSnapshotForPath:@"time"] value]];
            [e setLocation:[[child childSnapshotForPath:@"location"] value]];
            [e setIsAttending:[[child childSnapshotForPath:@"isAttending"] value]];
            
            // Get the guests.
            for(FIRDataSnapshot *guest in [[child childSnapshotForPath:@"guests"] children]) {
                [[e guests] addObject:[guest value]];
            }
            
            NSString * cellText = [[NSString alloc] initWithFormat:@"On %@ date at %@ time at %@ place with friend(s): %@ ", e.date, e.time , e.location, e.guests];
            
            [e setCellText:cellText];
            NSLog(@"PD8  capturing event: %@", e.cellText);
            if([e.isAttending isEqual:@NO]){
                [self.invites addObject:e];
            }
            
        }
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
    cell.textLabel.text = event.cellText;
    
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
