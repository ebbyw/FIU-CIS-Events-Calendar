//
//  EventsViewController.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 6/2/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "EventsViewController.h"
#import "EventCell.h"
#import "Event.h"
#import "EventSpeaker.h"
#import "Events.h"
#import "EventDetailViewController.h"
#import "UIImageView+Network.h"

#define kDarkBlueColor [UIColor colorWithRed:32/255.0f green:55/255.0f blue:106/255.0f alpha:1.0f]
#define kGoldColor [UIColor colorWithRed:203/255.0f green:183/255.0f blue:72/255.0f alpha:1.0f]

@interface EventsViewController (){
    NSArray *dataSource;
}

@end

@implementation EventsViewController

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
    // Do any additional setup after loading the view.
    dataSource = [[Events defaultEvents] upcomingEvents];
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    EventsViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderID" forIndexPath:indexPath];
//    return header;
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

    EventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventID" forIndexPath:indexPath];
    
    Event *cellEvent = [dataSource objectAtIndex:indexPath.item];

    NSDateComponents *eventDate = [[NSCalendar currentCalendar] components:unitFlags fromDate:cellEvent.eventTimeAndDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    
    [cell.cellDayValue setText:[NSString stringWithFormat:@"%02ld",(long)eventDate.day]];
    [cell.cellYear setText:[NSString stringWithFormat:@"%ld",(long)eventDate.year]];
    [cell.cellMonth setText:[dateFormatter stringFromDate:cellEvent.eventTimeAndDate]];
    [cell.cellEventType setText:cellEvent.eventType];
    [cell.cellEventTitle setText:cellEvent.eventName];
    [cell.cellSpeakerName setText: cellEvent.speaker.speakerName];
    [cell.cellSpeakerPhoto loadImageFromURL:[cellEvent.speaker imageURL]
                            placeholderImage:[UIImage imageNamed:@"FIUCISLogoSquare"]
                                     speaker:cellEvent.speaker];

    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataSource count];
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell Selected");
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = kDarkBlueColor;

}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
    NSLog(@"Cell deselected");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailView"])
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];

        EventDetailViewController *detailView = segue.destinationViewController;
        [detailView receiveEventObject:[dataSource objectAtIndex:indexPath.item]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)eventTypeChanged:(UISegmentedControl *)sender {
    NSLog(@"Segment Button Pressed, Value is %ld", (long)sender.selectedSegmentIndex);
    if(sender.selectedSegmentIndex == 0){
        dataSource = [[Events defaultEvents] upcomingEvents];
    }else{
        dataSource = [[Events defaultEvents] pastEvents];
    }
    [self.collectionView reloadData];
}
@end
