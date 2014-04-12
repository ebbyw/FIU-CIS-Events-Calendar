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

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %d/%d - %d/%d", range.startDay.day, range.startDay.month, range.endDay.day, range.endDay.month);
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
