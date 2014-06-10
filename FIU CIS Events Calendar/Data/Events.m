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
#import "NSString+HTML.h"

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
//    NSDateFormatter *dateFormatter;
    NSCalendar *gregorian;
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
                                   Event *currentEvaluatedEvent = (Event *) evaluatedObject;
                                   if([[currentEvaluatedEvent eventTimeAndDate] compare:[NSDate midnightYesterday]] == NSOrderedDescending){
//                                       NSLog(@"Adding To Upcoming: %@, %@", currentEvaluatedEvent.speaker.speakerName, currentEvaluatedEvent.eventName);
                                       return YES;
                                   }else{
                                       return NO;
                                   }
                                   
                               }
                               ];
        pastEventFilter = [NSPredicate
                           predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                           {
                               Event *currentEvaluatedEvent = (Event *) evaluatedObject;
                               
                               if([[currentEvaluatedEvent eventTimeAndDate] compare:[NSDate midnightYesterday]] == NSOrderedDescending){
                                   return NO;
                               }else{
//                                   NSLog(@"Adding To Past: (%@) %@, %@",currentEvaluatedEvent.eventTimeAndDate, currentEvaluatedEvent.speaker.speakerName, currentEvaluatedEvent.eventName);
                                   return YES;
                               }
                               
                           }
                           ];
        userAddedFilter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
                           {
                               return [[(Event *) evaluatedObject addedToUser] boolValue];
                           }
                           ];
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        gregorian = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSGregorianCalendar];
        NSLog(@"INITIALIZED EVENTS LIST HOLDER");
    }
    return self;
}

-(NSDate *) dateFromJSONString: (NSString *) jsonString{
    NSDateComponents *date = [[NSDateComponents alloc]init];
    
    [date setYear:[[jsonString substringWithRange:NSMakeRange(0,4)] intValue]];
    [date setMonth:[[jsonString substringWithRange:NSMakeRange(5,2)] intValue]];
    [date setDay:[[jsonString substringWithRange:NSMakeRange(8,2)] intValue]];
    [date setHour:[[jsonString substringWithRange:NSMakeRange(11,2)] intValue]];
    [date setMinute:[[jsonString substringWithRange:NSMakeRange(14,2)] intValue]];
    [date setSecond:[[jsonString substringWithRange:NSMakeRange(17,2)] intValue]];

    return [gregorian dateFromComponents:date];
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
            NSLog(@"Speaker fetch successful %lu speakers previously stored in database.", (unsigned long)[speakersResult count]);
            [currentSpeakers addObjectsFromArray:speakersResult];
        }
        
        
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
            NSLog(@"Event fetch successful %lu events previously stored in database.", (unsigned long)[eventsResult count]);
            [currentEvents addObjectsFromArray:eventsResult];
            
        }
        
    }
    
    //Now update currentEvents and currentSpeakers with data retrieved from JSON
    
    for(NSDictionary *eventInfo in jsonObject){
        //Event Date, formatted and converted  to NSDate
        NSDate *eventTimeAndDate = [self dateFromJSONString: [eventInfo valueForKey:@"eventDate" ]];
        BOOL addTheEvent = ![self checkIfEventExists:eventInfo andDate:eventTimeAndDate];
        
        if(addTheEvent){
            if(![self addEvent:eventInfo andDate:eventTimeAndDate]){
                NSLog(@"Event Not Added");
            }else{
//                NSLog(@"New Event Added: %@ on %@", getValue(eventInfo, @"eventName"), eventTimeAndDate);
            }
        }
        
    }
    
    allEvents = [NSArray arrayWithArray:currentEvents];
    
    allUserEvents = [NSMutableArray arrayWithArray:[allEvents filteredArrayUsingPredicate:userAddedFilter]];
    
    allSpeakers = [NSArray arrayWithArray:currentSpeakers];
    
    appDelegate(saveContext);
}

-(BOOL) checkIfEventExists: (NSDictionary *) eventData andDate: (NSDate *) date{
    //Check for existing speaker
    NSString *speakerNameTrimmed = [getValue(eventData,@"speakerName") stringByDecodingHTMLEntities];
    speakerNameTrimmed = [speakerNameTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    EventSpeaker *existingSpeaker;
    
    for(EventSpeaker *speaker in currentSpeakers){
        if([speaker.speakerName localizedCaseInsensitiveCompare: speakerNameTrimmed ] == NSOrderedSame){
            //We've found a speaker in our speakers list that matches the speaker of the current event
            existingSpeaker = speaker;
        }
    }
    
    if(existingSpeaker){
//        NSLog(@"Identical Speaker. %@", speakerNameTrimmed);
        //Update Speaker Information if needed
        if([existingSpeaker.speakerDepartment localizedCaseInsensitiveCompare:getValue(eventData, @"speakerDepartment")] !=NSOrderedSame){
            [existingSpeaker setSpeakerDepartment:getValue(eventData, @"speakerDepartment")];
        }
        if([existingSpeaker.speakerOrganization localizedCaseInsensitiveCompare:getValue(eventData, @"speakerOrganization")] !=NSOrderedSame){
            [existingSpeaker setSpeakerOrganization:getValue(eventData, @"speakerOrganization")];
        }
        
        if([existingSpeaker.bio localizedCaseInsensitiveCompare:getValue(eventData, @"bio")]!=NSOrderedSame){
            [existingSpeaker setBio: getValue(eventData, @"bio")];
        }
        
        //Look through speakers events for this event
        Event *duplicateEvent;
        for(Event *speakersEvent in existingSpeaker.events){
            if([speakersEvent.eventName localizedCaseInsensitiveCompare:getValue(eventData, @"eventName")] == NSOrderedSame){
                if([speakersEvent.eventType localizedCaseInsensitiveCompare:getValue(eventData, @"eventType")] == NSOrderedSame){
                duplicateEvent = speakersEvent;
                }
            }
        }
        
        if(duplicateEvent){
//            NSLog(@"Duplicate Event found, (%@) %@, %@", getValue(eventData, @"eventDate"), speakerNameTrimmed, getValue(eventData, @"eventName"));
            //TODO Add some kind of management/consolidation in order to make sure we have the most up to dat event info
            return YES;
        }else{
            NO;
        }
        
    }
    return NO;
}

-(BOOL) addEvent: (NSDictionary *) eventData andDate:(NSDate *) date{
    EventSpeaker *theSpeaker;
    
    NSString *speakerNameTrimmed = [getValue(eventData,@"speakerName") stringByDecodingHTMLEntities];
    speakerNameTrimmed = [speakerNameTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    for(EventSpeaker *speaker in currentSpeakers){
        if([speaker.speakerName localizedCaseInsensitiveCompare:speakerNameTrimmed] == NSOrderedSame){
            theSpeaker = speaker;
            break;
        }
    }
    
    if(theSpeaker == nil){
        //Create a new speaker
        NSLog(@"Creating new Speaker, %@", speakerNameTrimmed);
        theSpeaker = [NSEntityDescription insertNewObjectForEntityForName:@"EventSpeaker"
                                                   inManagedObjectContext:context];
        [theSpeaker setSpeakerName:speakerNameTrimmed];
        [theSpeaker setSpeakerDepartment: [getValue(eventData, @"speakerDepartment") stringByDecodingHTMLEntities]];
        [theSpeaker setSpeakerOrganization:[getValue(eventData, @"speakerOrganization") stringByDecodingHTMLEntities]];
        [theSpeaker setImageLink:getValue(eventData, @"imageLink")];
        [theSpeaker setBio:[getValue(eventData, @"bio") stringByDecodingHTMLEntities]];
        [currentSpeakers addObject:theSpeaker];
    }
    
    Event *newEvent =[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                   inManagedObjectContext:context];
    [newEvent setEventName:[getValue(eventData, @"eventName") stringByDecodingHTMLEntities]];
    [newEvent setEventTimeAndDate:date];
    [newEvent setEventLink:getValue(eventData, @"eventLink")];
    [newEvent setEventType:[getValue(eventData, @"eventType") stringByDecodingHTMLEntities]];
    [newEvent setEventDescription:[getValue(eventData, @"description") stringByDecodingHTMLEntities]];
    [newEvent setEventLocation:[getValue(eventData, @"eventLocation") stringByDecodingHTMLEntities]];
    
    [currentEvents addObject:newEvent];
    [[theSpeaker events] addObject:newEvent];
    [newEvent setSpeaker:theSpeaker];
    
    return YES;
}


@end
