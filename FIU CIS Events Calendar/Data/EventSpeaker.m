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

- (void) downloadAndStoreImage{
    NSLog(@"Image Link is: %@", [self imageLink]);
    NSURL *imageURL = [NSURL URLWithString:[self imageLink]];
    NSURLRequest *imageReq = [NSURLRequest requestWithURL:imageURL];
    connection = [[NSURLConnection alloc] initWithRequest:imageReq
                                                 delegate:self
                                         startImmediately:YES];
}

-(void) connection: (NSURLConnection *) conn didReceiveData:(NSData *)data{
    [imageData appendData:data];
}

-(void) connectionDidFinishLoading: (NSURLConnection *) conn{
    NSLog(@"Image Fetch Successful");
    [self setPhoto: [UIImage imageWithData:imageData]];
    
}

-(void) connection: (NSURLConnection *) conn didFailWithError:(NSError *)error{
    connection = nil;
    imageData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

@end
