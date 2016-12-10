//
//  LoginViewController.h
//  playd8coordin8
//
//  Created by Bryan Scott on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseAuthUI;

@interface LoginViewController : UIViewController <FUIAuthDelegate>

@property (strong, nonatomic) FIRUser *user;
@property BOOL hasLaunchedAlredy;

@end
