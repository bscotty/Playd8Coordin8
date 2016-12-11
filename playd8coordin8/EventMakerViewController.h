//
//  EventMakerViewController.h
//  playd8coordin8
//
//  Created by Bryan Scott on 12/7/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventMakerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *guestField; // TODO: Fix this better for more than one guest, probably
- (IBAction)cancelEventCreation:(id)sender;
- (IBAction)createEvent:(id)sender;

@end
