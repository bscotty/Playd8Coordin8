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
    self.yourTableView.delegate = self;
    self.yourTableView.delegate = self;
    self.committedEvents = [[NSMutableArray alloc] init];
    self.pendingInvites = [[NSMutableArray alloc] init];
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
            if([e.isAttending isEqual:@YES]){
                [self.committedEvents addObject:e];
            }else{
                [self.pendingInvites addObject:e];
            }
            
        }
        [self.yourTableView reloadData];
        
        
        if ([self.pendingInvites count]==0)
        {
            UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height/2, 300, 60)];
            fromLabel.text =@"No Result";
            fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            fromLabel.backgroundColor = [UIColor clearColor];
            fromLabel.textColor = [UIColor lightGrayColor];
            fromLabel.textAlignment = NSTextAlignmentLeft;
            [self.view addSubview:fromLabel];
            [self.yourTableView setHidden:YES];
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
-(NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    if (section == 0){
        if([self.committedEvents count] > 0){
            if([self.committedEvents count] > 3){
                rowCount = [self.committedEvents count];
            }else{
                rowCount = 3;
            }
        }else{
            rowCount = 1;
        }
       
    }
    if(section == 1){
        if([self.pendingInvites count] > 0){
            if([self.pendingInvites count] > 3){
                rowCount = [self.pendingInvites count];
            }else{
                rowCount = 3;
            }
        }else{
            rowCount = 1;
        }
       
    }
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"PD8 TABLEVIEW SECTIONSINVIEW");
    NSInteger numOfSections = 0;
    if ([self.pendingInvites count] > 0)
    {
        self.yourTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
        //yourTableView.backgroundView   = nil;
        self.yourTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.yourTableView.bounds.size.width, self.yourTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        //yourTableView.backgroundView = noDataLabel;
        //yourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.yourTableView.backgroundView = noDataLabel;
        self.yourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Committed Events";
    else
        return @"Pending Invites";
}

-(UITableViewCell *)tableView: (UITableView *)tableView
        cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Cell"];
    }
    
    if(indexPath.section == 0){
        Event* currentEvent = [self.committedEvents objectAtIndex:indexPath.row];
        NSString *cellValue = currentEvent.cellText;
        cell.textLabel.text = cellValue;
    }else{
        Event* currentEvent = [self.pendingInvites objectAtIndex:indexPath.row];
        NSString *cellValue = currentEvent.cellText;
        cell.textLabel.text = cellValue;
    }
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
