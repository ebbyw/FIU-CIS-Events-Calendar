//
//  TestView.m
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventDetailView.h"
#import "EventsView.h"
#import <QuartzCore/QuartzCore.h>

typedef enum { SectionDateTime, SectionWhere, SectionSpeaker } Sections;

@interface EventDetailView ()

@end

@implementation EventDetailView

-(id) initWithEvent: (Event *) theEvent{
    
    self = [self initWithNibName:@"EventDetailView" bundle:nil];
    
    if(self){
        currentEvent = theEvent;
        [[self navigationItem] setTitle:[currentEvent eventType]];
            }
    
    //create and add button to open an actionsheet with social media choices to pick from
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                  style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    self.navigationItem.rightBarButtonItem = addButton;
  
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
    //[act showInView:[UIApplication sharedApplication].keyWindow];

}

//RAUL MODIFY THE BELOW METHOD

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Entered actionsheet");
            switch (buttonIndex) {
                case 0: //Add to My Events
                    [currentEvent setAddedToUser:[NSNumber numberWithBool:YES]];
                    break;
                case 1: //Email
                    NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
                    
                    break;
                case 2: //iCal
                    NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
                    break;
                case 3: //Twitter
                    NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
                    break;
                case 4: //Facebook
                    NSLog(@"The %@ button was tapped", [actionSheet buttonTitleAtIndex:buttonIndex]);
                    break;
                default: //Out of bounds
                    break;
            }

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Add picture from the class
    UIImage *image = [UIImage imageWithData:[[currentEvent speaker] photo]];
    [theImage setImage:image];
                                                                    //x, y   Width lenght
    UILabel *lbEventName = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 170, 110)];
    lbEventName.numberOfLines = 0;
    lbEventName.textAlignment = NSTextAlignmentLeft;
    //lbEventName.layer.borderColor = [UIColor blackColor].CGColor;
    //lbEventName.layer.borderWidth = 1.0;
    //lbEventName.textColor = [UIColor blueColor];
    lbEventName.font = [UIFont fontWithName:@"ArialMT" size:15];
    
    
    //lbEventName.lineBreakMode = YES;
    lbEventName.text = [currentEvent eventName];
    [self.view addSubview:lbEventName];
   
       // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //switch (section) {
    //    case 0: return 4;
       return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
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
           NSString *getString = [NSString stringWithFormat: @ "\t%@ \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t%@ \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t%@", [[currentEvent speaker] speakerName], [[currentEvent speaker] speakerOrganization], [[currentEvent speaker ]speakerDepartment]];
            
//            stringForCell =getString;
            stringForCell = [@"Speaker:\t" stringByAppendingString:getString];
            
        }
    
    [cell.textLabel setText:stringForCell];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 2){
        return 100;
    }
    return 44;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
