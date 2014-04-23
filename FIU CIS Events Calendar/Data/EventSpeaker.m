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


@implementation EventSpeaker

@dynamic bio;
@dynamic imageLink;
@dynamic speakerName;
@dynamic speakerOrganization;
@dynamic speakerDepartment;
@dynamic events;
@dynamic photo;

- (void) downloadAndStoreImage{

    UIImage * result;
    
   [self setPhoto:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self imageLink]]]];
    result = [UIImage imageWithData:[self photo]];
    if(result != nil){
        NSLog(@"IMAGE DOWNLOAD SUCCESS");
    }else{
        NSLog(@"IMAGE DOWNLOAD FAIL");
        [self setPhoto:UIImageJPEGRepresentation([UIImage imageNamed:@"FIUCISLogoSquare"], 0.5)];
    }
}


@end
