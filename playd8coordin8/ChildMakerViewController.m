//
//  ChildMakerViewController.m
//  playd8coordin8
//
//  Created by Bryan Scott on 12/11/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ChildMakerViewController.h"
#import "Event.h"

@import Firebase;

@interface ChildMakerViewController ()

@end

@implementation ChildMakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createChild:(id)sender {
    // Puts the Child onto Firebase.
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRUser *user = [FIRAuth auth].currentUser;
    
    FIRDatabaseReference *userData = [[ref child:@"users"] child:user.uid];
    
    NSString *key = [userData childByAutoId].key;
    
    NSDictionary *post = @{@"name": _childName.text,
                            @"age": _childAge.text,
                            @"bio": _childBio.text,
                           @"type": _childType.text};
    
    NSDictionary *childUpdates = @{[[[@"/users/" stringByAppendingString:user.uid] stringByAppendingString:@"/"] stringByAppendingString:key]: post};
    [ref updateChildValues:childUpdates];
    
    // Reset the text fields.
    _childName.text = @"Name";
    _childAge.text = @"Age";
    _childType.text = @"Child, Dog, Lizard, etc.";
    _childBio.text = @"Allergies, Behaviors, Quirks";
    
    // Setup the alert, which creates a popup.
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Good News!"
                                message:@"Congratulations on your new Child!"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    // Setup the Action, which dismisses the viewcontroller when it's done.
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {[self
                                                               dismissViewControllerAnimated:YES
                                                               completion:nil];}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)cancelChildCreation:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
