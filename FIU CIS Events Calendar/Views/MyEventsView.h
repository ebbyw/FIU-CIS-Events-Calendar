//
//  MyEventsView.h
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEventsView : UITableViewController{
    NSDateFormatter* df_local;

    NSArray *myEvents;
}

@end
