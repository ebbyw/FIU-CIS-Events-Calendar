//
//  Events.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventSpeaker;
@class Event;
@class SplashViewController;

@interface Events : NSObject{
    
    SplashViewController *splashView;
    
    NSArray *allEvents;
    NSArray *allSpeakers;
    NSMutableArray *allUserEvents;
    
    NSMutableArray *currentSpeakers;
    NSMutableArray *currentEvents;
    
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSArray *jsonObject;

+(Events *) defaultEvents;
-(NSArray *) allEvents;
-(NSArray *) allSpeakers;
-(NSArray *) allUserEvents;

-(EventSpeaker *) createSpeaker;
-(Event *) createEvent;
-(void) addEventToUserList: (Event *) eventToAdd;
-(void) removeEventFromUserList: (Event *) eventToRemove;
-(NSString *) dataStoragePath;
-(void) saveChanges;
-(void) loadEventsList;
-(void) setSplashView: (SplashViewController *) controller;
@end
