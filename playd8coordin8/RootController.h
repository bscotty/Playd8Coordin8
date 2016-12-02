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
#import "HomeViewController.h"
#import "InviteViewController.h"
#import "EventViewController.h"
#import "UserViewController.h"

@interface RootController : UIViewController

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) InviteViewController *inviteViewController;
@property (strong, nonatomic) EventViewController *eventViewController;
@property (strong, nonatomic) UserViewController *userViewController;


@end

