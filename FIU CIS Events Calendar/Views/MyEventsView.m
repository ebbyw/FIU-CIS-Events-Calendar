//
//  MyEventsView.m
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "MyEventsView.h"
#import "Events.h"
#import "Event.h"
#import "EventCellTableViewCell.h"

@interface MyEventsView ()

@end

@implementation MyEventsView

-(id) init{
    self = [self initWithStyle:UITableViewStylePlain];
    if(self){
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSLog(@"My Events init Called");
        [self.navigationItem setTitle:@"My Events"];
        [[self tabBarItem] setTitle:@"MyEvents"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"MyEventsIcon"]];
        df_local = [[NSDateFormatter alloc] init] ;
        [df_local setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
        //        NSLog(@"Local Time Zone is %@", [NSTimeZone timeZoneWithName:@"EST"]);
        [df_local setDateFormat:@"MMM - dd"];

    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"EventCellTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"myEventCell"];
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
    // Return the number of rows in the section.
    return [[[Events defaultEvents] allUserEvents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Creating a Cell");
    EventCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myEventCell"];
    
    if(!cell){
        cell = [[EventCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myEventCell"];
    }
    
    Event *thisCellEvent = [[[Events defaultEvents] allUserEvents] objectAtIndex:[indexPath row]];
    NSLog(@"%@",[thisCellEvent eventType]);
    [[cell cellEventDate] setText: [df_local stringFromDate:[thisCellEvent eventTimeAndDate]]];
    
    [[cell cellEventTitle] setText:[NSString stringWithFormat:@"%@",[thisCellEvent eventType]]];
    
    //    NSLog(@"Compare UTC: %@ to Local: %@",[theEvent eventTimeAndDate],localTime);
    
    [ [cell cellEventPhoto] setImage:[UIImage imageWithData:[[thisCellEvent speaker] photo] ]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *thisCellEvent = [[[Events defaultEvents] allUserEvents] objectAtIndex:[indexPath row]];
    NSLog(@"Date for this Event is: %@",[thisCellEvent eventTimeAndDate]);
}

@end
