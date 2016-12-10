//
//  EventMakerViewController.m
//  playd8coordin8
//
//  Created by Bryan Scott on 12/7/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "EventMakerViewController.h"
#import "Event.h"

@import Firebase;

@interface EventMakerViewController ()

@end

@implementation EventMakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PD8 VIEWDIDLOAD EVENTMAKER");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Creates an Event Object based on the UI Fields. These events do not have keys. Maybe move this to another ViewController Object where our events are generated?

- (IBAction)createEvent:(id)sender {
    NSString *time = _timeField.text;
    NSString *date = _dateField.text;
    NSString *location = _locationField.text;
    NSString *guest = _guestField.text;

    Event *e = [[Event alloc] init];
    [e setTime:time];
    [e setDate:date];
    [e setLocation:location];
    [e addGuest:guest];
    [e setIsAttending:@YES];
   
    // Puts the Event object onto Firebase.
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *events = [ref child:@"events"];
    
    NSString *key = [events childByAutoId].key;

    NSDictionary *post = @{@"attending:": e.isAttending,
                                 @"time": e.time,
                                 @"date": e.date,
                             @"location": e.location,
                               @"guests": e.guests};
    
    NSDictionary *childUpdates = @{[@"/events/" stringByAppendingString:key]: post};
    [ref updateChildValues:childUpdates];
    
    _timeField.text = @"Time";
    _dateField.text = @"Date";
    _locationField.text = @"Location";
    _guestField.text = @"Guest";
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"My Alert"
                                                 message:@"Your event has been created."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction =
                    [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {[self
                     dismissViewControllerAnimated:YES
                                        completion:nil];}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)cancelEventCreation:(id)sender {
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
