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
    
    NSMutableArray *currentSpeakers;
    NSMutableArray *currentEvents;
    
    
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSArray *jsonObject;

+(Events *) defaultEvents;
-(NSArray *) allEvents;
-(NSArray *) allSpeakers;

-(EventSpeaker *) createSpeaker;
-(Event *) createEvent;
-(NSString *) dataStoragePath;
-(BOOL) saveChanges;
-(void) loadEventsList;
-(void) setSplashView: (SplashViewController *) controller;
@end
