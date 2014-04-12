//
//  EventsView.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "DSLCalendarView.h"

@interface EventsView : UITableViewController <DSLCalendarViewDelegate>{
    NSDateFormatter* df_local;
    IBOutlet DSLCalendarView *headerView;
}
-(UIView *) headerView;
@end
