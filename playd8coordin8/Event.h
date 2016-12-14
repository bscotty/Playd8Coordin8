//
//  Event.h
//  playd8coordin8
//
//  Created by Bryan Scott on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, atomic) NSString *key;
@property (strong, atomic) NSString *name;
@property (strong, atomic) NSDate *date;
@property (strong, atomic) NSString *location;
@property (strong, atomic) NSMutableArray *guests;
@property (atomic) NSNumber *isAttending; // 1 = YES; 0 = NO;
@property (strong, atomic) NSString *cellText;

- (void) addGuest:(NSString *)guestName;

- (NSString *) getDateAndTimeForFirebase;

- (NSString *) getDateAndTimeForUI;

- (void) setDateFromFormattedString:(NSString *)s;

@end
