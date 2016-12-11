//
//  UserViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "UserViewController.h"
#import "Child.h"
@import Firebase;

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childTableView.delegate = self;
    self.childTableView.dataSource = self;
    // Do any additional setup after loading the view.
    if([[FIRAuth auth] currentUser]) {
        FIRUser *user = [FIRAuth auth].currentUser;
        NSString *email = user.email;
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        NSString *name = user.displayName;
        
        NSURL *photoURL = user.photoURL;
        
        _userName.text = name;
        _userEmail.text = email;
        _userImage.image=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:photoURL]];
       
    }
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRUser *user = [FIRAuth auth].currentUser;
    
    FIRDatabaseReference *userData = [[ref child:@"users"] child:user.uid];
    
    NSLog(@"PD8 getting children of user");
    
    [userData observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *_Nonnull snapshot){
        NSLog(@"PD8 OBSERVING USERDATA DB");
        self.children = [[NSMutableArray alloc] init];
        for(FIRDataSnapshot* child in snapshot.children){
            //create a new child
            Child* c = [[Child alloc] init];
            
            //Get the Firebase Key, along with the age, type, bio, and name
            [c setKey: [child key]];
            [c setAge: [[child childSnapshotForPath:@"age"] value]];
            [c setType: [[child childSnapshotForPath:@"type"] value]];
            [c setBio: [[child childSnapshotForPath:@"bio"] value]];
            [c setName: [[child childSnapshotForPath:@"name"] value]];
            
            NSString * cellText = [[NSString alloc] initWithFormat:@"%@, Age %@, %@", c.type, c.age, c.bio];
            [c setCellText: cellText];
            NSLog(@"PD8 capturing child %@", c.name);
            
            [self.children addObject:c];
        }
        [self.childTableView reloadData];
    } withCancelBlock:^(NSError * _Nonnull error){
        NSLog(@"PD8 OBSERVE ERROR");
        NSLog(@"%@", error.localizedDescription);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table 
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"PD8 TABLEVIEW ROWSINSECTION");
    return [self.children count];
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
    Child *child = self.children[indexPath.row];
    cell.textLabel.text = child.name;
    cell.detailTextLabel.text = child.cellText;
    
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
