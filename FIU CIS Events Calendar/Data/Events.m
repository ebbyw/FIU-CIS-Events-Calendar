//
//  Events.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "Events.h"
#import "Event.h"
#import "EventSpeaker.h"
#import "AppDelegate.h"
#import "SplashViewController.h"

#define appDelegate(z) [(AppDelegate *)[[UIApplication sharedApplication] delegate] z]
#define getValue(x,y) (([ x valueForKey:y] == [NSNull null]) ? nil : [ x valueForKey:y])

@implementation Events

@synthesize jsonObject;

+(Events *) defaultEvents{
    static Events *defaultEvents = nil;
    if(!defaultEvents){
        defaultEvents = [[super allocWithZone:nil]init];
    }
    return defaultEvents;
}

+(id) allocWithZone:(struct _NSZone *)zone{
    return [self defaultEvents];
}

-(id) init{
    self = [super init];
    
    if(self){
        model = appDelegate(managedObjectModel);
        context = appDelegate(managedObjectContext);
        
        NSLog(@"INITIALIZED EVENTS LIST HOLDER");
    }
    return self;
}

-(NSArray *) allEvents{
    return allEvents;
}

-(NSArray *) allSpeakers{
    return allSpeakers;
}

-(NSArray *) allUserEvents{
    NSPredicate *userAddedFilter = [NSPredicate
                                    predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                                    {
                                        return [[(Event *) evaluatedObject addedToUser] boolValue];
                                    }
                                    ];
    allUserEvents = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:userAddedFilter]];
    NSLog(@"All Events Size is %d", [allUserEvents count]);
    return (NSArray *) allUserEvents;
}

-(void) addEventToUserList: (Event *) eventToAdd{
    [allUserEvents addObject:eventToAdd];
}


-(EventSpeaker *) createSpeaker{
    return nil;
}

-(Event *) createEvent{
    return nil;
}

-(NSString *) dataStoragePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"eventsData.data"];
}

-(BOOL) saveChanges{
    return NO;
}

-(void) setSplashView: (SplashViewController *) controller{
    splashView = controller;
}

-(void) loadEventsList{
    if(splashView == nil){
        NSLog(@"SPLASH VIEW IS NIL");
    }else{
        NSLog(@"Current Progress is %f", [splashView progressValue]);
    }
    float progressIncrement;
    if(jsonObject == nil){
        NSLog(@"JSON IS NIL");
        progressIncrement = (1.0f -  [splashView progressValue])/5.0f;
    }else{
        progressIncrement = (1.0f - [splashView progressValue])/([jsonObject count]+ 5);
    }
    
    currentSpeakers = [[NSMutableArray alloc] init];
    currentEvents = [[NSMutableArray alloc] init];
    // Set Up local app data with data from our stored database
    
    if(!allSpeakers){
        NSFetchRequest *speakersRequest =[[NSFetchRequest alloc]init];
        NSEntityDescription *speakerEntity = [[model entitiesByName] objectForKey:@"EventSpeaker"];
        
        [speakersRequest setEntity:speakerEntity];
        
        NSSortDescriptor *speakerSort = [NSSortDescriptor sortDescriptorWithKey:@"speakerName"
                                                                      ascending:YES];
        [speakersRequest setSortDescriptors: [NSArray arrayWithObject:speakerSort]];
        
        NSError *speakersError;
        NSArray *speakersResult = [context executeFetchRequest:speakersRequest
                                                         error:&speakersError];
        
        if(!speakersResult) {
            [NSException raise:@"Fetch Failed"
                        format:@"Reason: %@", [speakersError localizedDescription]];
        }else{
            NSLog(@"Speaker fetch successful %lu itmes", (unsigned long)[speakersResult count]);
            [currentSpeakers addObjectsFromArray:speakersResult];
        }
        [splashView incrementProgressBar:progressIncrement];
        
    }
    
    if(!allEvents){
        NSFetchRequest *eventRequest =[[NSFetchRequest alloc]init];
        NSEntityDescription *eventEntity = [[model entitiesByName] objectForKey:@"Event"];
        
        [eventRequest setEntity:eventEntity];
        
        NSSortDescriptor *eventSort = [NSSortDescriptor sortDescriptorWithKey:@"eventTimeAndDate"
                                                                    ascending:YES];
        [eventRequest setSortDescriptors: [NSArray arrayWithObject:eventSort]];
        
        NSError *eventsError;
        NSArray *eventsResult = [context executeFetchRequest:eventRequest
                                                       error:&eventsError];
        
        if(!eventRequest) {
            [NSException raise:@"Fetch Failed"
                        format:@"Reason: %@", [eventsError localizedDescription]];
        }else{
            NSLog(@"Event fetch successful %lu itmes", (unsigned long)[eventsResult count]);
            [currentEvents addObjectsFromArray:eventsResult];
            
        }
        [splashView incrementProgressBar:progressIncrement];
        
    }
    
    //Now update currentEvents and currentSpeakers with data retrieved from JSON
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    
    for(NSDictionary *eventInfo in jsonObject){
        //Event Date, formatted and converted  to NSDate
        NSMutableString *eventDate = [[NSMutableString alloc]initWithString:[eventInfo valueForKey:@"eventDate" ]];
        [eventDate appendString:[eventInfo valueForKey:@"eventTime"]];
        NSDate *eventTimeAndDate = [dateFormatter dateFromString: eventDate];
        BOOL addTheEvent = ![self checkIfEventExists:eventInfo andDate:eventTimeAndDate];
        
        if(addTheEvent){
            if(![self addEvent:eventInfo andDate:eventTimeAndDate]){
                NSLog(@"Event Not Added");
            }
        }
        [splashView incrementProgressBar:progressIncrement];
        
    }
    
    allEvents = [NSArray arrayWithArray:currentEvents];
    
    NSPredicate *userAddedFilter = [NSPredicate
                                    predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                                    {
                                        return [[(Event *) evaluatedObject addedToUser] boolValue];
                                    }
                                    ];
    
    allUserEvents = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:userAddedFilter]];
    
    [splashView incrementProgressBar:progressIncrement];
    
    allSpeakers = [NSArray arrayWithArray:currentSpeakers];
    [splashView incrementProgressBar:progressIncrement];
    
    //    NSLog(@"progress bar value = %f", progressValue);
    appDelegate(saveContext);
    [splashView incrementProgressBar:progressIncrement];
    
}

-(BOOL) checkIfEventExists: (NSDictionary *) eventData andDate: (NSDate *) date{
    //Check for existing speaker
    for(EventSpeaker *speaker in currentSpeakers){
        NSString *speakerNameTrimmed = getValue(eventData,@"speakerName");
        speakerNameTrimmed = [speakerNameTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([speaker.speakerName localizedCaseInsensitiveCompare: speakerNameTrimmed ] == NSOrderedSame){
            //We've found a speaker in our speakers list that matches the speaker of the current event
            //            NSLog(@"Identical Speaker");
            //Update Speaker Information if needed
            if([speaker.speakerDepartment localizedCaseInsensitiveCompare:getValue(eventData, @"speakerDepartment")] !=NSOrderedSame){
                [speaker setSpeakerDepartment:getValue(eventData, @"speakerDepartment")];
            }
            if([speaker.speakerOrganization localizedCaseInsensitiveCompare:getValue(eventData, @"speakerOrganization")] !=NSOrderedSame){
                [speaker setSpeakerOrganization:getValue(eventData, @"speakerOrganization")];
            }
            
            if([speaker.bio localizedCaseInsensitiveCompare:getValue(eventData, @"bio")]!=NSOrderedSame){
                [speaker setBio: getValue(eventData, @"bio")];
            }
            
            // Check if this speaker already has this event under their events set
            for(Event *speakerEvent in currentEvents ){
                if([speakerEvent.eventName localizedCaseInsensitiveCompare: getValue(eventData, @"eventName")] == NSOrderedSame){
                    //                    NSLog(@"Identical Event");
                    //Identical Event Name found in speakers events list
                    //Check if any info needs to be updated
                    //TODO Consider adding an "updated" property/flag to Events to let users know the event has been updated
                    //Check For Time/Date Change
                    if([speakerEvent.eventTimeAndDate compare: date] != NSOrderedSame){
                        [speakerEvent setEventTimeAndDate:date];
                    }
                    
                    //Check For Location Change
                    if([speakerEvent.eventLocation localizedCaseInsensitiveCompare:getValue(eventData, @"eventLocation")] != NSOrderedSame){
                        [speakerEvent setEventLocation:getValue(eventData, @"eventLocation")];
                    }
                    
                    //Check For Type Change
                    if([speakerEvent.eventType localizedCaseInsensitiveCompare:getValue(eventData, @"eventType")] != NSOrderedSame){
                        [speakerEvent setEventType:getValue(eventData, @"eventType")];
                    }
                    
                    
                    //Check For Description Change
                    if([speakerEvent.eventDescription localizedCaseInsensitiveCompare:getValue(eventData, @"description")] != NSOrderedSame){
                        [speakerEvent setEventDescription:getValue(eventData, @"description")];
                    }
                    
                    //Check For Event Link Change
                    if( [speakerEvent.eventLink localizedCaseInsensitiveCompare:getValue(eventData, @"eventLink")]!= NSOrderedSame){
                        [speakerEvent setEventLink:getValue(eventData, @"eventLink")];
                    }
                    
                    return YES;
                }//END EVENTNAME ==
            }// END FOR EVENT
        }//END IF SPEAKER ==
    }//END FOR EVENTSPEAKER
    return NO;
}

-(BOOL) addEvent: (NSDictionary *) eventData andDate:(NSDate *) date{
    EventSpeaker *theSpeaker;
    
    NSString *speakerNameTrimmed = getValue(eventData,@"speakerName");
    speakerNameTrimmed = [speakerNameTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    for(EventSpeaker *speaker in currentSpeakers){
        if([speaker.speakerName localizedCaseInsensitiveCompare:speakerNameTrimmed] == NSOrderedSame){
            theSpeaker = speaker;
            break;
        }
    }
    
    if(theSpeaker == nil){
        //Create a new speaker
        theSpeaker = [NSEntityDescription insertNewObjectForEntityForName:@"EventSpeaker"
                                                   inManagedObjectContext:context];
        [theSpeaker setSpeakerName:speakerNameTrimmed];
        [theSpeaker setSpeakerDepartment:getValue(eventData, @"speakerDepartment")];
        [theSpeaker setSpeakerOrganization:getValue(eventData, @"speakerOrganization")];
        [theSpeaker setImageLink:getValue(eventData, @"imageLink")];
        [theSpeaker downloadAndStoreImage];
        [currentSpeakers addObject:theSpeaker];
    }
    
    Event *newEvent =[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                   inManagedObjectContext:context];
    [newEvent setEventName:getValue(eventData, @"eventName")];
    [newEvent setEventTimeAndDate:date];
    [newEvent setEventLink:getValue(eventData, @"eventLink")];
    [newEvent setEventType:getValue(eventData, @"eventType")];
    [newEvent setEventDescription:getValue(eventData, @"description")];
    [newEvent setEventLocation:getValue(eventData, @"eventLocation")];
    
    [currentEvents addObject:newEvent];
    [[theSpeaker events] addObject:newEvent];
    [newEvent setSpeaker:theSpeaker];
    
    return YES;
}


@end
