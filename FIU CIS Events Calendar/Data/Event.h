//
//  Event.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EventSpeaker.h"

@class EventSpeaker;

@interface Event : EventSpeaker

@property (nonatomic, retain) NSDate * eventTimeAndDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventLink;
@property (nonatomic, retain) NSString * eventLocation;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * userNotes;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSNumber * canceled;
@property (nonatomic, retain) EventSpeaker *speaker;


@end
