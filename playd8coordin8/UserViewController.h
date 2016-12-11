//
//  UserViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface UserViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSMutableArray *children;
@property (weak, nonatomic) IBOutlet UITableView *childTableView;

@end
