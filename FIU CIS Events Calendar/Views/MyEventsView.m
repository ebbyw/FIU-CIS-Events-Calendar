//
//  MyEventsView.m
//  FIU CIS Events Calendar
//
//The MIT License (MIT)
//
//Copyright (c) 2014 Raul Carvajal, Eduardo Toledo, Ebtissam Wahman
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "MyEventsView.h"
#import "Events.h"
#import "Event.h"
#import "EventCellTableViewCell.h"
#import "EventDetailView.h"

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
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[Events defaultEvents]removeEventFromUserList:[[[Events defaultEvents]allUserEvents] objectAtIndex:[indexPath row]]];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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
    EventDetailView *myEventsDetailView = [[EventDetailView alloc] initAsMyEvent:thisCellEvent];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        UINavigationController *detailViewNavController = [[UINavigationController alloc] initWithRootViewController:myEventsDetailView];
        NSMutableArray *controllers = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
        [controllers setObject:detailViewNavController atIndexedSubscript:1];
        self.splitViewController.viewControllers = (NSArray *)controllers;
    }else{
        [self.navigationController pushViewController:myEventsDetailView animated:YES];
    }
}

@end
