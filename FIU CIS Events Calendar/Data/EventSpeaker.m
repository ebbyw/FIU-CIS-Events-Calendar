//
//  EventSpeaker.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventSpeaker.h"


@implementation EventSpeaker

@dynamic bio;
@dynamic imageLink;
@dynamic speakerName;
@dynamic speakerOrganization;
@dynamic speakerDepartment;
@dynamic events;
@dynamic photo;

<<<<<<< HEAD
- (void) downloadAndStoreImage{

    UIImage * result;
    
   [self setPhoto:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self imageLink]]]];
    result = [UIImage imageWithData:[self photo]];
    if(result != nil){
        NSLog(@"SUCCESS");
    }else{
        NSLog(@"FAIL");
        [self setPhoto:UIImageJPEGRepresentation([UIImage imageNamed:@"FIUCISLogoSquare"], 0.5)];
    }
}


=======
>>>>>>> FETCH_HEAD
@end
