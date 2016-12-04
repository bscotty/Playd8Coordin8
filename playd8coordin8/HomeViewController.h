//
//  HomeViewController.h
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface HomeViewController : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
