//
//  ViewController.m
//  PlaydateCoordinate
//
//  Created by Bryan Scott on 11/17/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "RootController.h"

//Views from tab bar
#import "HomeViewController.h"
#import "InviteViewController.h"
#import "EventViewController.h"
#import "UserViewController.h"

// Add this to the header of your file, e.g. in ViewController.m
// after #import "ViewController.h"
#import "Event.h"



@interface RootController ()


@end

@implementation RootController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"Home"];
    self.homeViewController.view.frame = self.view.frame;
    [self presentViewController:self.homeViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) switchToInviteView:(id)sender{
    self.inviteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Invite"];
    self.inviteViewController.view.frame = self.view.frame;
    //not sure if this will work
    [self presentViewController:self.inviteViewController animated:YES completion:nil];
}

-(IBAction) switchToEventView:(id)sender{
    self.eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Event"];
    self.eventViewController.view.frame = self.view.frame;
    [self presentViewController:self.eventViewController animated:YES completion:nil];
}

-(IBAction) switchToUserView:(id)sender{
    self.userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"User"];
    self.userViewController.view.frame = self.view.frame;
    [self presentViewController:self.userViewController animated:YES completion:nil];
}

-(IBAction) switchToHomeView:(id)sender{
    self.homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    self.homeViewController.view.frame = self.view.frame;
    [self presentViewController:self.homeViewController animated:YES completion:nil];
}
@end
