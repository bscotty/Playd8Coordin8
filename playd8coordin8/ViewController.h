//
//  ViewController.h
//  PlaydateCoordinate
//
//  Created by Bryan Scott on 11/17/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Firebase.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

