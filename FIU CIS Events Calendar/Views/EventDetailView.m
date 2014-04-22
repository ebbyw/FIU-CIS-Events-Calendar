//
//  EventDetailView.m
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventDetailView.h"
#import "EventsView.h"
#import "Event.h"
#import "Events.h"
#import "EventSpeaker.h"
#import "MyEventsView.h"
#import <Social/Social.h>
#import <EventKit/EventKit.h>

typedef enum { SectionDateTime, SectionWhere, SectionSpeaker } Sections;

@interface EventDetailView ()

@end

@implementation EventDetailView

-(id) initWithEvent: (Event *) theEvent{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if(self){
        currentEvent = theEvent;
        notesMode = NO;
        [[self navigationItem] setTitle:[currentEvent eventType]];
        self.view = self.tableView;
        
        //create and add button to open an actionsheet with social media choices to pick from
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    return self;
}

-(id) initAsMyEvent: (Event *) theEvent{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if(self){
        currentEvent = theEvent;
        notesMode = NO;
        [[self navigationItem] setTitle:@"My Event Details"];
        
        notesButton = [[UIBarButtonItem alloc] initWithTitle:@"Notes"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(showNotes)];
        self.navigationItem.leftBarButtonItem = notesButton;
        
        //create and add button to open an actionsheet with social media choices to pick from
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    return self;
}

-(void) showActionSheet: (id) sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add To My Events",@"Email", @"iCal", @"Twitter", @"Facebook", nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[self.view window]];
    
}

//RAUL MODIFY THE BELOW METHOD

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Entered actionsheet");
    NSURL *theEventLink = [NSURL URLWithString:[currentEvent eventLink]];
    switch (buttonIndex) {
        case 0:{ //Add to My Events
            [[Events defaultEvents] addEventToUserList:currentEvent];
            MyEventsView *myEventsView = (MyEventsView *)[[self.tabBarController viewControllers] objectAtIndex:1];
            [myEventsView.tableView reloadData];
        }
            break;
        case 1: //Email
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
        case 2: //iCal
            NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
            [self setiCalEvent];
            break;
        case 3: //Twitter
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
        case 4: //Facebook
        {
            NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
            //                    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            //                    {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:@"I'm thinking of attending:"];
            [controller addURL:theEventLink];
            [self presentViewController:controller animated:YES completion:Nil];
            //                    }
            
        }
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
    
    // Check if App has Permission to Post to the Calendar
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted){
            //---- code here when user allows your app to access their calendar.
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        }else
        {
            //----- code here when user does NOT allow your app to access their calendar.
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        }
    }];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Add picture from the class
    
    UIImage *image = [UIImage imageWithData:[[currentEvent speaker] photo]];
    [theImage setImage:image];
    lbEventName.text = [currentEvent eventName];
    
}

#pragma mark - Header Methods

-(void) viewWillAppear:(BOOL)animated{
    [self updateHeaderValues];
}


-(UIView *) headerView{
    if(!headerView){
        [[NSBundle mainBundle] loadNibNamed:@"EventDetailHeader"
                                      owner:self
                                    options:nil];
        [self updateHeaderValues];
    }
    
    return headerView;
}

-(void) updateHeaderValues{
    
    [lbEventName  setText:[currentEvent eventName]];
    
    if([[currentEvent speaker] photo] != nil){
        [theImage setImage:[UIImage imageWithData:[[currentEvent speaker] photo]]];
    }
}

-(UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return [self headerView];
    }
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return [[self headerView] bounds].size.height;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(notesMode){
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    static NSString *textCellIdentifier = @"TextViewCell";
    
    if(!notesMode){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.numberOfLines = 0;
        }
        
        NSString *stringForCell;
        
        
        if (indexPath.section == 0)
        {
            NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
            [dformat setDateFormat:@"MM-dd-yyyy' @ 'HH:mm:ss"];
            
            NSString *myDate = [dformat stringFromDate:[currentEvent eventTimeAndDate]];
            
            stringForCell = [@"Date / Time: " stringByAppendingString: [NSString stringWithFormat:@"%@", myDate]];
            
        }    //cell.textLabel.text = [@"Where: " stringByAppendingString:[currentEvent eventLocation]];
        else if (indexPath.section == 1)
        {
            stringForCell = [@"Where: " stringByAppendingString:[currentEvent eventLocation]];
            
        }
        else
        {
            NSString *getString = [NSString stringWithFormat: @ "\t%@\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t%@\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t%@", [[currentEvent speaker] speakerName], [[currentEvent speaker] speakerOrganization], [[currentEvent speaker ]speakerDepartment]];
            
            //            stringForCell =getString;
            stringForCell = [@"Speaker:\t" stringByAppendingString:getString];
            
        }
        
        [cell.textLabel setText:stringForCell];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.numberOfLines = 0;
    }
    
    cellTextView = [[UITextView alloc] initWithFrame:cell.contentView.bounds];
    cellTextView.backgroundColor = [UIColor clearColor];
    cellTextView.textColor = [UIColor blackColor];
    cellTextView.returnKeyType = UIReturnKeySend;
    cellTextView.enablesReturnKeyAutomatically = YES;
    cellTextView.editable = YES;
    cellTextView.scrollEnabled = YES;
    cellTextView.opaque =YES;
    cellTextView.clipsToBounds = YES;
    cellTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    cellTextView.delegate = self;
    cellTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cellTextView.font = [UIFont systemFontOfSize:18];
    cellTextView.text = [currentEvent userNotes];
    if(cellTextView.text.length < 1){
        cellTextView.text = @"Type any notes here";
    }
    [cell.contentView addSubview: cellTextView];
    
    return cell;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    NSLog(@"touchesBegan:withEvent:");
    [cellTextView resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(notesMode){
        [cellTextView becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([cellTextView.text compare:@"Type any notes here"] == NSOrderedSame){
        cellTextView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [currentEvent setUserNotes:[textView text]];
    if(cellTextView.text.length < 1){
        cellTextView.text = @"Type any notes here";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(!notesMode){
        if(indexPath.section == 2){
            return 100;
        }
        return 44;
    }
    return 320;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showNotes{
    notesMode = YES;
    [[self navigationItem] setTitle:@"Notes"];
    [notesButton setTitle:@"Details"];
    [notesButton setAction:@selector(showEventDetails)];
    [self.tableView reloadData];
}

-(void) showEventDetails{
    notesMode = NO;
    [[self navigationItem] setTitle:@"My Event Details"];
    [notesButton setTitle:@"Notes"];
    [notesButton setAction:@selector(showNotes)];
    [self.tableView reloadData];
    
}



@end
