//
//  InviteViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@import Firebase;

@interface InviteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *inviteTable;
@property (nonatomic) NSMutableArray<Event*> *invites;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
