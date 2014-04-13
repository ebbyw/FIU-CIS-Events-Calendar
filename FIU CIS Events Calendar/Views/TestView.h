//
//  TestView.h
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventSpeaker.h"

@interface TestView : UIViewController{
    
    __weak IBOutlet UIImageView *theImage;
    Event *currentEvent;
}

-(id) initWithEvent: (Event *) theEvent;

@end
