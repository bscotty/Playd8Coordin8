//
//  Event.m
//  playd8coordin8
//
//  Created by Bryan Scott on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "Event.h"

@implementation Event

- (void)addGuest:(NSString *)guestName {
    if(_guests == nil) {
        _guests = [[NSMutableArray alloc] init];
    }
    [_guests addObject:guestName];
}

@end
