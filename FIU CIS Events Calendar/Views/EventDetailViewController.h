//
//  EventDetailViewController.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 6/3/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <EventKitUI/EventKitUI.h>

@class Event;

@interface EventDetailViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *eventSpeakerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *eventDayAndMonth;
@property (weak, nonatomic) IBOutlet UILabel *eventYear;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;

-(void) receiveEventObject: (Event *) eventToDetail;
- (IBAction)presentActionMenu:(id)sender;
- (IBAction)goBack:(id)sender;

@end
