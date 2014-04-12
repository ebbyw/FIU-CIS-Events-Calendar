//
//  EventsView.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventsView.h"
#import "Events.h"
#import "EventCellTableViewCell.h"
#import "AppDelegate.h"

#define appDelegate(z) [(AppDelegate *)[[UIApplication sharedApplication] delegate] z]


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
        [df_local setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
        //        NSLog(@"Local Time Zone is %@", [NSTimeZone timeZoneWithName:@"EST"]);
        [df_local setDateFormat:@"MMM - dd"];
        currentEvents = [[Events defaultEvents] allEvents];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"EventCellTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"eventCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Header View Methods

-(UIView *) headerView{
    if(!headerView){
        CGRect headerRect = CGRectMake(0, 0, 320, 420);
        headerView = [[DSLCalendarView alloc] initWithFrame:headerRect];
        [headerView setDelegate:self];
    }
    
    return headerView;
}

-(void) resizeHeaderViewToFit{
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height = self.headerView.bounds.size.height;
    self.headerView.frame = headerFrame;
}

-(UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    NSLog(@"View for Header Called");
    return [self headerView];
}

-(CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [[self headerView] bounds].size.height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentEvents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    if(!cell){
        cell = [[EventCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    
    Event *theEvent = [ currentEvents objectAtIndex:[indexPath row]];
    
    [[cell cellEventDate] setText: [df_local stringFromDate:[theEvent eventTimeAndDate]]];
    
    [[cell cellEventTitle] setText:[NSString stringWithFormat:@"%@",[theEvent eventType]]];
    
    //    NSLog(@"Compare UTC: %@ to Local: %@",[theEvent eventTimeAndDate],localTime);
    
    [ [cell cellEventPhoto] setImage:[UIImage imageWithData:[[theEvent speaker] photo] ]];
    
    return cell;
}

-(void) getEventsForRange{
    
    NSPredicate *filter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings){
        return [currentRangeFilter containsDate: [(Event *) evaluatedObject eventTimeAndDate]];
    }];
    
    currentEvents = [[[Events defaultEvents] allEvents] filteredArrayUsingPredicate:filter];

    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *theEvent = [currentEvents objectAtIndex:[indexPath row]];
    NSLog(@"Date for this Event is: %@",[theEvent eventTimeAndDate]);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 
//}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %d/%d - %d/%d", range.startDay.day, range.startDay.month, range.endDay.day, range.endDay.month);
        currentRangeFilter = range;
        [self getEventsForRange];
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
//    currentRangeFilter = range;
//    [self getEventsForRange];
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    [self resizeHeaderViewToFit];
    [self.tableView reloadData];
    
    NSLog(@"Now showing %@", month);
}



- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end
