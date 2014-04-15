//
//  TestView.m
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventDetailView.h"
#import "EventsView.h"
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(addToUsersList)];
    self.navigationItem.rightBarButtonItem = rightButton;
  
    return self;
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
    UIImage *image = [UIImage imageWithData:[[currentEvent speaker] photo]];
    [theImage setImage:image];
    
    UILabel *lbEventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 180, 50)];
    lbEventName.lineBreakMode = YES;
    lbEventName.text = [currentEvent eventType];
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
    }
    
    NSString *stringForCell;
    
    if (indexPath.section == 0)
    {
        NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
        [dformat setDateFormat:@"yyyy-MM-dd' @ 'HH:mm:ss"];
        
        NSString *myDate = [dformat stringFromDate:[currentEvent eventTimeAndDate]];
        
        stringForCell = [@"Date / Time: " stringByAppendingString: [NSString stringWithFormat:@"%@", myDate]];
    }    //cell.textLabel.text = [@"Where: " stringByAppendingString:[currentEvent eventLocation]];
    else if (indexPath.section == 1)
            {
                stringForCell = [@"Where: " stringByAppendingString:[currentEvent eventLocation]];
            }
        else
        {
           NSString *getString = [NSString stringWithFormat: @ "%@ \n %@ %@", [[currentEvent speaker] speakerName], [[currentEvent speaker] speakerOrganization], [[currentEvent speaker ]speakerDepartment]];
            
            stringForCell = [@"Speaker: " stringByAppendingString:getString];
        }
    
    [cell.textLabel setText:stringForCell];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) addToUsersList{
    NSLog(@"Added to Users List");
    [currentEvent setAddedToUser: [NSNumber numberWithBool:YES]];
}



@end
