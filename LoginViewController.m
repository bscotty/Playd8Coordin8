//
//  LoginViewController.m
//  playd8coordin8
//
//  Created by Bryan Scott on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "LoginViewController.h"
#import "RootController.h"
@import Firebase;
@import FirebaseAuthUI;

@import FirebaseGoogleAuthUI;
//@import FirebaseFacebookAuthUI;
//@import FirebaseTwitterAuthUI;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"PD8 LOGIN VIEWDIDLOAD");
}

- (void)viewDidAppear:(BOOL)animated {
    [FIRApp configure];
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
    // You need to adopt a FUIAuthDelegate protocol to receive callback
    authUI.delegate = self;
    
    NSArray<id<FUIAuthProvider>> *providers = @[
                                                [[FUIGoogleAuth alloc] init],
                                                /*[[FUIFacebookAuth alloc] init],
                                                 [[FUITwitterAuth alloc] init],
                                                 */];
    
    authUI.providers = providers;
    
    UINavigationController *authViewController = [authUI authViewController];
    [self presentViewController:authViewController
                       animated:true
                     completion:^(void){
                         NSLog(@"PD8 Authentication successful.");
                     }];
    
    NSLog(@"PD8 Authentication?");
}

- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
    if(error) {
        return;
    }
    _user = user;
    
    NSLog(@"PD8 User Found");
    // Segue to the root view?
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
