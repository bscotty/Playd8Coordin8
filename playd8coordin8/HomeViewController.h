//
//  HomeViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView *upcomingTableView;
@property (nonatomic, weak) IBOutlet UITableView *yourTableView;
@property (copy, nonatomic) NSArray *upcomingEvents;
@property (copy, nonatomic) NSArray *yourEvents;
@end
