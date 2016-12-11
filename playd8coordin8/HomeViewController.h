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


@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *yourTableView;
@property (nonatomic) NSMutableArray<Event*> *committedEvents; //goes into upcoming table view ( I know this is super confusing, sorry)
@property (nonatomic) NSMutableArray<Event*> *pendingInvites; //goes into your table view
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
