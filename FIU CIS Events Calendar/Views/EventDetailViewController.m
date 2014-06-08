//
//  EventDetailViewController.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 6/3/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Event.h"
#import "EventSpeaker.h"
#import "UIImageView+Network.h"
#import "RightPaneTextDisplayViewController.h"
#import <Social/Social.h>
#import <EventKit/EventKit.h>

@interface EventDetailViewController (){
    Event *currentEvent;
    BOOL iCalSuccess;
    UIAlertView *alertView; //for displaying iCal info
}

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Being Created");
    }
    return self;
}

-(void) receiveEventObject: (Event *) eventToDetail{
    currentEvent = eventToDetail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    static unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    if(currentEvent){
        NSDateComponents *eventDate = [[NSCalendar currentCalendar] components:unitFlags fromDate:currentEvent.eventTimeAndDate];
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMM"];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mm a"];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

        NSLog(@"%@",currentEvent.eventTimeAndDate);
        [self.eventDayAndMonth setText:[NSString stringWithFormat:@"%ld %@",(long)eventDate.day,
                                        [monthFormatter stringFromDate:currentEvent.eventTimeAndDate]]];
        [self.eventYear setText:[NSString stringWithFormat:@"%ld",(long)eventDate.year]];
        [self.navigationItem setTitle:currentEvent.eventType];
        [self.eventTitle setText:currentEvent.eventName];
        [self.eventSpeakerName setText: currentEvent.speaker.speakerName];
        [self.eventTime setText:[timeFormatter stringFromDate:currentEvent.eventTimeAndDate]];
        [self.eventLocation setText:currentEvent.eventLocation];
        [self.eventSpeakerPhoto loadImageFromURL:[currentEvent.speaker imageURL]
                                placeholderImage:[UIImage imageNamed:@"FIUCISLogoSquare"]
                                         speaker:currentEvent.speaker];
    }
    
    
}

-(IBAction) presentActionMenu: (id) sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email Event", @"Add to iCal", @"Tweet About It", nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[self.view window]];
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Entered actionsheet");
    NSURL *theEventLink = [NSURL URLWithString:[currentEvent eventLink]];
    switch (buttonIndex) {
        case 0: //Email
        {
            //Email Subject
            NSString *emailTitle =@"Test Email";
            //Email Content
            NSString *messageBody = [NSString stringWithFormat:@"Thinking of attending: %@", theEventLink];
            
            
            //to address
            //                    NSArray *toRecipient =[NSArray arrayWithObject:@"rcarv006@fiu.edu"];
            MFMailComposeViewController *mc =[[MFMailComposeViewController alloc]init];
            mc.mailComposeDelegate = self;
            
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            //                    [mc setToRecipients:toRecipient];
            if (mc!=nil)
            {
                [self presentViewController:mc animated:YES completion:NULL];
            }
            
            NSLog(@"*/*/*/*/*/The %@ button was tapped*/*/*/*/*/*/*/", [actionSheet buttonTitleAtIndex:buttonIndex]);
            
        }
            
            break;
        case 1: //iCal
            NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
            [self setiCalEvent];
            break;
        case 2: //Twitter
        {// I added these curly braces
            NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
            //Twitter code copyPasta
            //                    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            //                    {
            SLComposeViewController *tweetSheet =
            [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [tweetSheet setInitialText:@"@FIUSCIS I'm thinking of attending:"];
            [tweetSheet addURL:theEventLink];
            
            tweetSheet.completionHandler =^(SLComposeViewControllerResult res)
            {
                if (res == SLComposeViewControllerResultDone)
                {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Success" message:@"Tweet Posted Successfully" delegate:self cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
                    
                    [alert show];
                }
                if(res == SLComposeViewControllerResultCancelled)
                {
                    
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Cancelled" message:@"Tweet Cancelled" delegate:self cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
                    [alert show];
                }
                
            };
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            //                    }
            
            
            
        }//and these curly braces
            break;
//        case 3: //Facebook
//        {
//            NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
//            //                    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//            //                    {
//            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            
//            [controller setInitialText:@"I'm thinking of attending:"];
//            [controller addURL:theEventLink];
//            [self presentViewController:controller animated:YES completion:Nil];
//            //                    }
//            
//        }
            break;
        default: //Out of bounds
            NSLog(@"Error, button is out of scope");
            break;
    }
    
}

// iCal Event

-(void) setiCalEvent {
    
    // Set iCal Event
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = [NSString stringWithFormat:@"%@: %@", currentEvent.eventType, currentEvent.eventName];
    
    event.startDate = currentEvent.eventTimeAndDate;
    event.endDate = [[NSDate alloc] initWithTimeInterval:3599 sinceDate:event.startDate];
    event.location = currentEvent.eventLocation;
    
    EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = eventStore;
    controller.event = event;
    controller.editViewDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated: controller completion:nil];
}

-(void) displayiCalAlert{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    
    UIAlertView *iCalAlert;
    
    if(iCalSuccess){
        iCalAlert = [[UIAlertView alloc] initWithTitle:@"Event Added to iCal!"
                                               message:[NSString stringWithFormat:@"Event added as \"%@\"",[NSString stringWithFormat:@"%@: %@", currentEvent.eventType, currentEvent.eventName]]
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
    }else{
        iCalAlert = [[UIAlertView alloc] initWithTitle:@"Unable to Add to iCal"
                                               message:@"Sorry, an error occured and the event was not added to iCal"
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    }
    
    [iCalAlert show];
}

/*  Mail composer Helper Method*/
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Email Canceled" message:@"Email has been canceled"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        }
            break;
        case MFMailComposeResultSaved:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Email saved" message:@"Unsent email saved as draft"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
        }
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Mail sent" message:@"Email has been sent"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Mail sent Failure" message:@"Mail not sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
            NSLog(@"Mail Sent Failure: %@", [error localizedDescription]);
        }
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*  Mail Composer Helper method End   */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RightPaneTextDisplayViewController *rightPane = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SpeakerBio"])
    {
        [rightPane receiveTextForField:currentEvent.speaker.bio];
        
    }
    if([segue.identifier isEqualToString:@"EventDescription"]){
        [rightPane receiveTextForField:currentEvent.eventDescription];
    }
}

@end
