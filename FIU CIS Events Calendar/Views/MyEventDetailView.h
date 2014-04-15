//
//  MyEventDetailView.h
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 4/14/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventDetailView;


@interface MyEventDetailView : UIViewController{
    EventDetailView *eventDetailView;
    UIScrollView *scrollView;
    UIView *firstView;
    UIView *notesView;
}

-(id) initWithDetailView:(EventDetailView *) detailView;

@end
