//
//  EventsView.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "NSDate+Reporting.h"
#import "EventsView.h"
#import "Event.h"
#import "Events.h"
#import "EventCellTableViewCell.h"
#import "AppDelegate.h"
#import "DSLCalendarMonthView.h"
#import "DSLCalendarDayView.h"


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
        [[self tabBarItem] setImage:[UIImage imageNamed:@"EventsIcon"]];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getThisMonthsEvents];
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
    headerFrame.size.height = self.headerView.bounds.size.height +5 ;
    self.headerView.frame = headerFrame;
}

-(UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    NSLog(@"View for Header Called");
    return [self headerView];
}

-(CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [[self headerView] bounds].size.height +5 ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([currentEvents count] > 0){
        noEvents = NO;
     return [currentEvents count];
    }
    noEvents = YES;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!noEvents){
    EventCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    if(!cell){
        NSLog(@"Creating Cell for Events");
        cell = [[EventCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    
    Event *theEvent = [ currentEvents objectAtIndex:[indexPath row]];
    
    [[cell cellEventDate] setText: [df_local stringFromDate:[theEvent eventTimeAndDate]]];
    
    [[cell cellEventTitle] setText:[NSString stringWithFormat:@"%@",[theEvent eventType]]];
    
    //    NSLog(@"Compare UTC: %@ to Local: %@",[theEvent eventTimeAndDate],localTime);
    
    [ [cell cellEventPhoto] setImage:[UIImage imageWithData:[[theEvent speaker] photo] ]];
    
    return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noEvents"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noEvents"];
    }
    
    [[cell textLabel] setText:@"No events!"];
    
    return cell;
    
    
}

-(void) getThisMonthsEvents{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    
    NSDate *thisMonth = [[(DSLCalendarView *)headerView visibleMonth] date];
    thisMonth = [NSDate midnightOfDate:thisMonth];
    NSLog(@"This month is %@,",thisMonth);
    
    NSDateComponents *firstOfMonth = [cal components:unitFlags fromDate:[NSDate firstDayOfMonthFromDate:thisMonth]];
    NSDateComponents *lastOfMonth = [cal components:unitFlags fromDate:[NSDate firstDayOfNextMonthFromDate:thisMonth]];
    
    currentRangeFilter = [[DSLCalendarRange alloc] initWithStartDay:firstOfMonth endDay:lastOfMonth];
    [self getEventsForRange];
    
    DSLCalendarMonthView *thisMonthView = [(DSLCalendarView* )headerView currentMonthView];
    
    NSSet *allDayViews = [thisMonthView dayViews];
    
    for(Event *event in currentEvents){
        NSDateComponents *day = [cal components: unitFlags fromDate:[event eventTimeAndDate]];
        
        for (DSLCalendarDayView *dayView in allDayViews) {
            if([dayView day].day  == day.day){
                [dayView markDate];
            }
        }
    }
    
}

-(void) getEventsForRange{
    NSLog(@"Called Get Events For Range %@ - %@", currentRangeFilter.startDay, currentRangeFilter.endDay);
    
    NSPredicate *filter = [NSPredicate
                           predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings){
                               return [currentRangeFilter containsDate: [(Event *) evaluatedObject eventTimeAndDate]];
                           }
                           ];
//    NSLog(@"Current Event Count Prior To Filter %d", [currentEvents count]);
    
    currentEvents = [[[Events defaultEvents] allEvents] filteredArrayUsingPredicate:filter];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"eventTimeAndDate"
                                                                ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    currentEvents = [currentEvents sortedArrayUsingDescriptors:sortDescriptors];
    
//    NSLog(@"Received %d Events", [currentEvents count]);
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!noEvents){
    Event *theEvent = [currentEvents objectAtIndex:[indexPath row]];
    NSLog(@"Date for this Event is: %@",[theEvent eventTimeAndDate]);
    [theEvent setAddedToUser:[NSNumber numberWithBool:YES]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (YES) { // Only select a single day
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
    [self getThisMonthsEvents];
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    [self resizeHeaderViewToFit];
    [self.tableView reloadData];
    
    NSLog(@"Now showing %@", month);
    [calendarView resetAccelerometerBool];
}



- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end
