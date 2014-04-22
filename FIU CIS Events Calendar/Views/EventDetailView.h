//
//  EventDetailView.h
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Event;
@class EventSpeaker;

@interface EventDetailView : UITableViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate>
{
    __weak IBOutlet UIImageView *theImage;
    __weak IBOutlet UILabel *lbEventName;
    IBOutlet UIView *headerView;
    Event *currentEvent;
    BOOL notesMode;
    UIBarButtonItem *notesButton;
    UITextView *cellTextView;
}

-(id) initWithEvent: (Event *) theEvent;
-(id) initAsMyEvent: (Event *) theEvent;
-(UIView *) headerView;
-(void) showActionSheet: (id) sender;


@end
