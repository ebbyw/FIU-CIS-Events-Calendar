//
//  Events.m
//  FIU CIS Events Calendar
//
//The MIT License (MIT)
//
//Copyright (c) 2014 Raul Carvajal, Eduardo Toledo, Ebtissam Wahman
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "Events.h"
#import "Event.h"
#import "EventSpeaker.h"
#import "AppDelegate.h"
#import "SplashViewController.h"
#import "NSDate+Reporting.h"

#define appDelegate(z) [(AppDelegate *)[[UIApplication sharedApplication] delegate] z]
#define getValue(x,y) (([ x valueForKey:y] == [NSNull null]) ? nil : [ x valueForKey:y])

@implementation Events{
    NSPredicate *upcomingEventFilter;
    NSPredicate *pastEventFilter;
    NSPredicate *userAddedFilter;
    NSSortDescriptor *dateSortAscending;
    NSSortDescriptor *dateSortDescending;
    NSArray *dateAscendingSortDescriptor;
    NSArray *dateDescendingSortDescriptor;
    NSDateFormatter *dateFormatter;
    
}

@synthesize jsonObject;
@synthesize currentProgress;

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
        dateSortAscending = [NSSortDescriptor sortDescriptorWithKey:@"eventTimeAndDate"
                                                          ascending:YES];
        dateSortDescending = [NSSortDescriptor sortDescriptorWithKey:@"eventTimeAndDate"
                                                           ascending:NO];
        dateAscendingSortDescriptor = [NSArray arrayWithObject:dateSortAscending];
        
        dateDescendingSortDescriptor = [NSArray arrayWithObject:dateSortDescending];
        upcomingEventFilter = [NSPredicate
                               predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                               {
                                   if([[(Event *) evaluatedObject eventTimeAndDate] compare:[NSDate midnightYesterday]] == NSOrderedDescending){
                                       return YES;
                                   }else{
                                       return NO;
                                   }
                                   
                               }
                               ];
        pastEventFilter = [NSPredicate
                           predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                           {
                               if([[(Event *) evaluatedObject eventTimeAndDate] compare:[NSDate midnightYesterday]] == NSOrderedDescending){
                                   return NO;
                               }else{
                                   return YES;
                               }
                               
                           }
                           ];
        userAddedFilter = [NSPredicate
                                        predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [[(Event *) evaluatedObject addedToUser] boolValue];
                                        }
                                        ];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
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

-(NSArray *) upcomingEvents{
    
    NSMutableArray *upcoming = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:upcomingEventFilter]];
    
    [upcoming sortUsingDescriptors:dateAscendingSortDescriptor];
    
    return upcoming;
    
}

-(NSArray *) pastEvents{
    
     NSMutableArray *past = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:pastEventFilter]];
    
    [past sortUsingDescriptors:dateDescendingSortDescriptor];
    
    return past;
}

-(NSArray *) allUserEvents{
    
    allUserEvents = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:userAddedFilter]];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"eventTimeAndDate"
                                                               ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    [allUserEvents sortUsingDescriptors:sortDescriptors];
    
    
    NSLog(@"All Events Size is %lu", (unsigned long)[allUserEvents count]);
    return (NSArray *) allUserEvents;
}

-(void) addEventToUserList: (Event *) eventToAdd{
    [eventToAdd setAddedToUser:[NSNumber numberWithBool:YES]];
    [self saveChanges];
    [self allUserEvents];
}

-(void) removeEventFromUserList: (Event *) eventToRemove{
    [eventToRemove setAddedToUser:[NSNumber numberWithBool:NO]];
    [self saveChanges];
    [self allUserEvents];
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

-(void) saveChanges{
    appDelegate(saveContext);
}

-(void) loadEventsList{
    
    if(jsonObject == nil){
        NSLog(@"JSON IS NIL");
        progressIncrement = (1.0f -  currentProgress)/5.0f;
    }else{
        progressIncrement = (1.0f - currentProgress)/([jsonObject count]+ 5);
    }
    
    currentSpeakers = [[NSMutableArray alloc] init];
    currentEvents = [[NSMutableArray alloc] init];
    // Set Up local app data with data from our stored database
    
    if(!allSpeakers){ //if the allSpeakers array has not been initialized,
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
            NSLog(@"Speaker fetch successful, %lu speakers previously present in Database.", (unsigned long)[speakersResult count]);
            [currentSpeakers addObjectsFromArray:speakersResult];
        }
        
        currentProgress += progressIncrement;
        
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
            NSLog(@"Event fetch successful %lu events previously present in Database.", (unsigned long)[eventsResult count]);
            [currentEvents addObjectsFromArray:eventsResult];
            
        }
        
        currentProgress += progressIncrement;
    }
    
    //Now update currentEvents and currentSpeakers with data retrieved from JSON
    
    for(NSDictionary *eventInfo in jsonObject){
        //Event Date, formatted and converted  to NSDate
        NSDate *eventTimeAndDate = [dateFormatter dateFromString: [eventInfo valueForKey:@"eventDate" ]];
        BOOL addTheEvent = ![self checkIfEventExists:eventInfo andDate:eventTimeAndDate];
        
        if(addTheEvent){
            if(![self addEvent:eventInfo andDate:eventTimeAndDate]){
                NSLog(@"Event Not Added");
            }
        }
        
        currentProgress += progressIncrement;
    }
    
    allEvents = [NSArray arrayWithArray:currentEvents];
    
    allUserEvents = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:userAddedFilter]];
    
    currentProgress += progressIncrement;
    
    allSpeakers = [NSArray arrayWithArray:currentSpeakers];
    currentProgress += progressIncrement;
    
    //    NSLog(@"progress bar value = %f", progressValue);
    appDelegate(saveContext);
    currentProgress += progressIncrement;
}

-(BOOL) checkIfEventExists: (NSDictionary *) eventData andDate: (NSDate *) date{
    //Check for existing speaker
    for(EventSpeaker *speaker in currentSpeakers){
        NSString *speakerNameTrimmed = getValue(eventData,@"speakerName");
        speakerNameTrimmed = [speakerNameTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([speaker.speakerName localizedCaseInsensitiveCompare: speakerNameTrimmed ] == NSOrderedSame){
            //We've found a speaker in our speakers list that matches the speaker of the current event
            NSLog(@"%@ found in system", speaker.speakerName);
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
        [theSpeaker setBio:getValue(eventData, @"bio")];
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
