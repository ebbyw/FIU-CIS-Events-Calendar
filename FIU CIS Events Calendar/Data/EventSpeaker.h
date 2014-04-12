//
//  EventSpeaker.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventSpeaker : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) NSString * speakerName;
@property (nonatomic, retain) NSString * speakerOrganization;
@property (nonatomic, retain) NSString * speakerDepartment;
@property (nonatomic, retain) NSMutableSet *events;
@end

@interface EventSpeaker (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
- (void) downloadAndStoreImage;

@end
