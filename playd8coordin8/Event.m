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
        [_guests addObject:guestName];
    } else {
        [_guests addObject:guestName];
    }
}

- (NSString *) getDateAndTimeForFirebase {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd HH:mm:ss"];  //20160217 13:14:22
    NSString *dateString = [dateFormatter stringFromDate: _date];
    
    return dateString;
}

- (NSString *) getDateAndTimeForUI {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate: _date];
    
    return dateString;
}

- (void)setDateFromFormattedString:(NSString *)s {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd HH:mm:ss"];
    
    _date = [dateFormatter dateFromString:s];
}



@end
