//
//  ChildMakerViewController.h
//  playd8coordin8
//
//  Created by Bryan Scott on 12/11/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildMakerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *childName;
@property (weak, nonatomic) IBOutlet UITextField *childAge;
// Add Picture Upload Somehow?
@property (weak, nonatomic) IBOutlet UITextField *childBio;
@property (weak, nonatomic) IBOutlet UITextField *childType;

@end
