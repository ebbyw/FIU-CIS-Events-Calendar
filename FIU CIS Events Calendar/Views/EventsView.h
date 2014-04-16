//
//  EventsView.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface EventsView : UITableViewController <DSLCalendarViewDelegate>{
    BOOL noEvents;
    NSDateFormatter* df_local;
    IBOutlet DSLCalendarView *headerView;
    NSArray *currentEvents;
    DSLCalendarRange *currentRangeFilter;
}
@end
