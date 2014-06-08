//
//  EventSpeaker.m
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

#import "EventSpeaker.h"

#define getValue(x,y) (([ x valueForKey:y] == [NSNull null]) ? nil : [ x valueForKey:y])

@implementation EventSpeaker

@dynamic bio;
@dynamic imageLink;
@dynamic speakerName;
@dynamic speakerOrganization;
@dynamic speakerDepartment;
@dynamic events;
@dynamic photo;

-(NSURL *) imageURL{
    return [NSURL URLWithString:self.imageLink];
}

+(EventSpeaker *) createSpeakerFromDictionary: (NSDictionary *) dict{
    EventSpeaker *theSpeaker = [[EventSpeaker alloc] init];
    NSString *speakerNameTrimmed = [getValue(dict,@"speakerName") stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    theSpeaker.speakerName = speakerNameTrimmed;
    theSpeaker.speakerDepartment = getValue(dict, @"speakerDepartment");
    theSpeaker.speakerOrganization = getValue(dict, @"speakerOrganization");
    theSpeaker.imageLink = getValue(dict, @"imageLink");
    theSpeaker.bio = getValue(dict, @"bio");
    
    return theSpeaker;
}

- (BOOL) updateSpeaker: (EventSpeaker *) otherSpeaker{
    BOOL updatedAValue = NO;
    if ([otherSpeaker.bio localizedCaseInsensitiveCompare: self.bio] != NSOrderedSame){
        self.bio = otherSpeaker.bio;
        updatedAValue = YES;
    }
    if ([otherSpeaker.speakerName localizedCaseInsensitiveCompare: self.speakerName] != NSOrderedSame){
        self.speakerName = otherSpeaker.speakerName;
        updatedAValue = YES;
    }
    if ([otherSpeaker.speakerOrganization localizedCaseInsensitiveCompare: self.speakerOrganization] != NSOrderedSame){
        self.speakerOrganization = otherSpeaker.speakerOrganization;
        updatedAValue = YES;
    }
    if ([otherSpeaker.speakerDepartment localizedCaseInsensitiveCompare: self.speakerDepartment] != NSOrderedSame){
        self.speakerDepartment = otherSpeaker.speakerDepartment;
        updatedAValue = YES;
    }
    
    //TODO: Need to clear photo cache and re-download image
    if ([otherSpeaker.imageLink localizedCaseInsensitiveCompare: self.imageLink] != NSOrderedSame){
        self.imageLink = otherSpeaker.imageLink;
        updatedAValue = YES;
    }
    
    return updatedAValue;
}

@end
