//
//  EventViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property (copy, nonatomic) NSMutableArray *events;

@end
