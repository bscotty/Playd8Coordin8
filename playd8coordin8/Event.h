//
//  Event.h
//  playd8coordin8
//
//  Created by Bryan Scott on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, atomic) NSString *date;
@property (strong, atomic) NSString *time;
@property (strong, atomic) NSString *location;
@property (strong, atomic) NSMutableArray *guests;


@end
