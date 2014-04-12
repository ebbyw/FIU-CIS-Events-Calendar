//
//  EventsView.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventsView.h"
#import "Events.h"

@interface EventsView ()

@end

@implementation EventsView

-(id) init{
    self = [self initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[self navigationItem] setTitle:@"Events"];
        [[self tabBarItem] setTitle:@"Events"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"appbar.calendar.day.png"]];
        df_local = [[NSDateFormatter alloc] init] ;
        [df_local setTimeZone:[NSTimeZone localTimeZone]];
//        NSLog(@"Local Time Zone is %@", [NSTimeZone timeZoneWithName:@"EST"]);
        [df_local setDateFormat:@"MMM - dd"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Events defaultEvents] allEvents] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    
    Event *theEvent = [ [ [Events defaultEvents] allEvents] objectAtIndex:[indexPath row]];
    NSMutableString *cellText = [[NSMutableString alloc]init];
    [cellText appendString:[df_local stringFromDate:[theEvent eventTimeAndDate]]];
    [cellText appendString:[NSString stringWithFormat:@": %@",[theEvent eventType]]];
//    NSLog(@"Compare UTC: %@ to Local: %@",[theEvent eventTimeAndDate],localTime);
    [ [cell textLabel] setText: cellText];
    
    return cell;
}

@end
