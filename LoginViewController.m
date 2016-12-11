//
//  LoginViewController.m
//  playd8coordin8
//
//  Created by Bryan Scott on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootController.h"
#import "SignInViewController.h"

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
    if (!(_hasLaunchedAlredy)) {
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
        [authViewController.view setBackgroundColor:[UIColor clearColor]];
        [self presentViewController:authViewController
                           animated:false
                         completion:^(void){
                             NSLog(@"PD8 Authentication successful.");
                         }];
        
        NSLog(@"PD8 Authentication?");
        _hasLaunchedAlredy = YES;
    } else {
        NSLog(@"PD8 Login already complete, segueing to main activity.");
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RootController *rc = [storyboard instantiateViewControllerWithIdentifier:@"Root"];
        appDelegate.window.rootViewController = rc;
        [appDelegate.window makeKeyAndVisible];
    }
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

// Objective-C
- (FUIAuthPickerViewController *)authPickerViewControllerForAuthUI:(FUIAuth *)authUI {
    return [[SignInViewController alloc] initWithAuthUI:authUI];
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
