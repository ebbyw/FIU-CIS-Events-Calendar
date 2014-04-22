//
//  EventDetailView.h
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventSpeaker.h"
#import <MessageUI/MessageUI.h>


@interface EventDetailView : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate>
{
    
    __weak IBOutlet UIImageView *theImage;
    Event *currentEvent;
    __weak IBOutlet UILabel *lbEvent;
    //__weak IBOutlet UIActionSheet *act;
}



-(id) initWithEvent: (Event *) theEvent;
-(id) initAsMyEvent: (Event *) theEvent;
-(void) showActionSheet: (id) sender;

@end
